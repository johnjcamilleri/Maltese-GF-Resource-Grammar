#!/usr/bin/php
<?php

// Timing
$time_start = microtime(true);

// Prepare some variables
if (!($type = @$GLOBALS['argv'][1]))
	die (" Usage: ".basename($GLOBALS['argv'][0])." type [--generate] [--cached]\n");
$files = array (
	'in' => "test/{$type}.gfs",
	'out' => "test/{$type}.out",
	'gold' => "test/{$type}.gold",
	'html' => "test/{$type}.html",
);
$text = array(
	'console' => '',
	'title' => "Tree linearisations for: $type",
	'generated' => sprintf("Generated %s", date('r')),
);
$scores = array(
	'total' => 0,
	'correct' => 0,
	'incorrect' => 0,
);

// ================

// Execute GF stuff and write output
if (in_array('--cached', $GLOBALS['argv'])) {
	echo " Reading directly from {$files['out']}\n";
} else {
	// Check infile exists
	if (!file_exists($files['in']))
		die (" Failed to read {$files['in']}\n");

	// Run GF & capture output
	echo " Reading from {$files['in']}\n";
	echo " Running GF\n";
	chdir( dirname(__FILE__) . '/../' );
	//exec("./_gf < {$files['in']} > {$files['out']}", $out, $return_status);
	exec("./_gf < {$files['in']}", $out, $return_status);
	if ($return_status != 0)
		die (" Failed\n");

	// TODO: Check that the output contains "linking... OK"
	if (strpos(implode("\n", $out), 'linking ... OK') === false)
		die (" GF compilation failed\n");

	// Clean output and write to file
	$n = 0;
	while (!preg_match('/^\w+>\s*\w+/', $out[$n])) $n++;
	$out = array_slice($out, $n);
	$out[0] = preg_replace('/^\w+>\s*/', '', $out[0]);
	$out = implode("\n", $out);
	if (false === file_put_contents($files['out'], $out))
		die (" Failed to write to {$files['out']}\n");

	// Write a gold file?
	if (in_array('--generate', $GLOBALS['argv'])) {
		if (file_exists($files['gold']))
			die (" Gold standard file {$files['gold']} already exists, please delete in manually if you want to re-generate it.\n");
		echo " Writing gold standard file to {$files['gold']}\n";
		if (false === file_put_contents($files['gold'], $out))
			die (" Failed.\n");
		else
			die (" Correct the linearisations in the gold file manually, and then re-run.\n");
	}
}

// Read output for parsing
$data = array(
	'out' => @file($files['out'], FILE_IGNORE_NEW_LINES),
	'gold' => @file($files['gold'], FILE_IGNORE_NEW_LINES),
);
if ($data['out'] === false)
	die (" Failed to read {$files['out']}\n");
if ($data['gold'] === false)
	die (" Failed to read {$files['gold']}. Maybe you need to create it with the --generate flag?\n");

// ================

// Recursive function for nesting as deep as we need
function nest($stack, &$branch) {
	if (count($stack) > 1) {
		$key = array_shift($stack);
		nest($stack, $branch[$key]);
	} else {
		$branch = $stack[0];
	}
}

// Process line by line & put into heirarchical array
$tree = array(); // overall structure
$ix = 0; // item index
foreach ($data['out'] as $n => $line) {

	// Have we reached a new entry?
	if (strlen($line) == 0) {
		$ix++;
	}

	// Process items
	//if (preg_match('/^(> )?(\w) \. (.*)/', $line, $matches)) {
	elseif (preg_match('/^(\w+> )?(\w) ([^:]+):(.*)$/', $line, $matches)) {

		// Split at space
		$columns = explode(' ',$matches[3]);

		// Get output and gold standard linearisations
		$columns[count($columns)-1] = array(
			'out' => trim($matches[4]),
			'gold' => substr(strrchr($data['gold'][$n], ':'), 2),
		);

		// Trim, and nest
		array_walk_recursive(&$columns, 'trim');
		nest($columns, $tree[$ix][$matches[2]]);

	}

	// Anything else is compiler output
	else
		$text['console'] .= $line . "\n";
}

// ================

// Process recursively for output

function disp($branch, $depth=0) {
	global $scores;
	if (is_array($branch)) {
		// Are we at the bottom OUT/GOLD case?
		if (array_key_exists('out', $branch) && array_key_exists('out', $branch)) {
			if (!empty($branch['gold']) && $branch['out'] == $branch['gold']) {
				$scores['correct']++;
				echo "<em>{$branch['out']}</em>" ;
			} else {
				echo "<em class='incorrect'>{$branch['out']}</em> &rarr; <em class='gold'>{$branch['gold']}</em>" ;
				$scores['incorrect']++;
			}
			$scores['total']++;
		}
		// recurse normally
		else foreach ($branch as $k => $v) {
			//printf("\n%s%-15s", str_repeat("\t", $depth), $k);
			echo "<div><b>$k</b>";
			disp($v, $depth+1);
			echo "</div>";
		}
	} else {
		echo $branch == '[]' ? '' : "<em>$branch</em>";
	}
}
/*
function dispHTML($branch, $depth=0) {
	if (is_array($branch)) {
		foreach ($branch as $k => $v) {
			printf('<h%2$d>%1$s</h%2$d>'."\n", $k, $depth+1);
			dispHTML($v, $depth+1);
		}
	} else {
		echo "<p>$branch</p>\n";
	}
}
*/

// Put together HTML output

ob_start();
foreach ($tree as $item) {
	disp($item);
	echo "<hr/>";
}
$text['out'] = ob_get_contents();
ob_end_clean();

// Format HTML file
echo " Formatting to HTML\n";
$HTML = <<<HTML
<html>
<head>
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
	<style type="text/css">
		body { font: 16px/1.5 serif; }
		div { margin-left: 2em; }
		#text-output { margin:0; color:#999; }
		#text-output b { display: inline-block; width: 10em; font-weight:normal; }
		#text-output em { font-style: italic; color:#000; }
		#text-output em.correct, .correct { color:green; }
		#text-output em.incorrect, .incorrect { color:red; }
		#text-output em.gold, .gold { background-color:gold; padding:0 5px; }

		table { border-collapse:collapse; border-spacing:0; }
		tr:nth-child(odd) { background-color:#eee; }
		tr.separator { background-color:#000; font-size:2px; }
		td { padding:0.2em 1em; border-width:1px 0; border-style:solid; border-color:#ccc; }
		td:last-child { font-style:italic; }

	</style>
</head>
<body>

<h1>{$text['title']}</h1>
<p><em>{$text['generated']}</em></p>
<p><span class="correct">{$scores['correct']} correct</span>, <span class="incorrect">{$scores['incorrect']} incorrect</span></p>
<hr/>

<div id="text-output">
{$text['out']}
</div>

</body>
</html>
HTML;

// Save to file
echo " Writing to file {$files['html']}\n";
@unlink($files['html']);
file_put_contents($files['html'], $HTML);

// ================

// Stop timing & display stats
$time_end = microtime(true);
$time_taken = $time_end - $time_start;
printf(" Done in %.2fs (completed at %s).\n", $time_taken, date('H:i'));
printf(" %s linearisations total: %d correct, %d incorrect.\n", $scores['total'], $scores['correct'], $scores['incorrect']);
