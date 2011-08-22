#!/usr/bin/php
<?php

// Timing
$time_start = microtime(true);

// Just some variables
if (!($type = @$GLOBALS['argv'][1]))
	die (" Usage: ".basename($GLOBALS['argv'][0])." type [--cached]\n");

$infile   = "test/{$type}.gfs";
$outfile  = "test/{$type}.out";
$htmlfile = "test/{$type}.out.html";
$command  = "./_gf < {$infile} > {$outfile}";

// ================

// Execute GF stuff and capture output
if (@$GLOBALS['argv'][2] == '--cached') {
	echo " Reading directly from {$outfile}\n";
} else {
	// Check infile exists
	if (!file_exists($infile))
		die (" Failed to read {$infile}.\n");

	echo " Reading from {$infile}\n";
	echo " Running GF\n";
	chdir( dirname(__FILE__) . '/../' );
	exec($command, $out, $return_status);
	if ($return_status != 0)
		die (" Failed.\n");
}
//$output = file($outfile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$output = file($outfile, FILE_IGNORE_NEW_LINES);
if ($output === false)
	die (" Failed to read {$outfile}.\n");

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

	// Have we reached a new entry?
	if (strlen($line) == 0) {
		$ix++;
	}

	// Process items
	//if (preg_match('/^(> )?(\w) \. (.*)/', $line, $matches)) {
	elseif (preg_match('/^(\w+> )?(\w) ([^:]+):(.*)$/', $line, $matches)) {

		// Split at space, add linearisation, trim, and nest
		$columns = explode(' ',$matches[3]);
		$columns[count($columns)-1] = $matches[4];
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

$TEXT_title = "Tree linearisations for: $type";
$TEXT_generated = sprintf("Generated %s", date('r'));

// ================

// Format into HTML
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

		table { border-collapse:collapse; border-spacing:0; }
		tr:nth-child(odd) { background-color:#eee; }
		tr.separator { background-color:#000; font-size:2px; }
		td { padding:0.2em 1em; border-width:1px 0; border-style:solid; border-color:#ccc; }
		td:last-child { font-style:italic; }
	</style>
</head>
<body>

<h1>{$TEXT_title}</h1>
<p><em>{$TEXT_generated}</em></p>
<hr/>

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
//file_put_contents($htmlfile, implode("\n", $output));

// ================

// Stop timing
$time_end = microtime(true);
$time_taken = $time_end - $time_start;
printf(" Done in %.2fs (completed at %s)\n", $time_taken, date('H:i'));
