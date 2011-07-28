#!/usr/bin/php
<?php

// Timing
$time_start = microtime(true);

// Just some variables
$outfile = 'test/nouns.out';
$command = './_gf < test/nouns.gfs > '.$outfile;
$htmlfile = 'test/nouns.out.html';
$TEXT = '';

// ================

// Execute GF stuff and capture output
if (@$GLOBALS['argv'][1] == '--cached') {
	echo " Reading directly from {$outfile}\n";
} else {
	echo " Running GF\n";
	chdir( dirname(__FILE__) . '/../' );
	exec($command, $out, $return_status);
	if ($return_status != 0)
		die (" Failed.\n");
}
$output = file($outfile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
if ($output === false)
		die (" Failed reading {$outfile}.\n");

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
$console_output = '';
foreach ($output as $n => $line) {

	// Skip timings
	if (preg_match('/^(> )?\d+ msec/', $line)) continue;

	// Process items
	elseif (preg_match('/^(> )?(\w) \. (.*)/', $line, $matches)) {

		// Have we reached a new entry?
		if ($matches[1]) {
			$ix++;
		}

		// Split at arrow and nest
		$columns = explode('=>',$matches[3]);
		$columns = array_map('trim', $columns);
		nest($columns, $tree[$ix][$matches[2]]);
	}

	// Anything else is compiler output
	else
		$console_output .= $line . "\n";
}

// ================

// Process recursively for output

function disp($branch, $depth=0) {
	if (is_array($branch)) {
		foreach ($branch as $k => $v) {
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

ob_start();
foreach ($tree as $item) {
	disp($item);
	echo "<hr/>";
}
$TEXT_out = ob_get_contents();
ob_end_clean();


// ================

// Format into HTML
echo " Formatting to HTML\n";
$HTML = <<<HTML
<html>
<head>
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
	<style type="text/css">
		body { font: 18px/1.5 serif; color:#999; }
		div { margin-left: 2em; }
		#text-output { margin:0; }
		#text-output b { display: inline-block; width: 10em; font-weight:normal; }
		#text-output em { font-style: italic; color:#000; }

		table { border-collapse:collapse; border-spacing:0; }
		tr:nth-child(odd) { background-color:#eee; }
		tr.separator { background-color:#000; font-size:2px; }
		td { padding:0.2em 1em; border-width:1px 0; border-style:solid; border-color:#ccc; }
		td:last-child { font-style:italic; }
	</style>
</head>
<body>


<div id="text-output">
{$TEXT_out}
</div>

</body>
</html>
HTML;


/*
<table>{$HTML_table}</table>
<a href="#compiler-output">Compiler output</a>
<pre id="compiler-output">{$HTML_console}</pre>
*/


// Save to file
echo " Writing to file $htmlfile\n";
@unlink($htmlfile);
file_put_contents($htmlfile, $HTML);

// ================

// Stop timing
$time_end = microtime(true);
$time_taken = $time_end - $time_start;
printf(" Done in %.2fs (completed at %s)\n", $time_taken, date('H:i'));
