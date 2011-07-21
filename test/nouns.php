#!/usr/bin/php
<?php

// Just some variables
$command = './_gf < test/nouns.gfs';
$outfile = 'test/nouns.out.html';

// Execute GF stuff and capture output
echo " Running GF\n";
chdir( dirname(__FILE__) . '/../' );
exec($command, $output, $return_status);
if ($return_status != 0)
	die (" Failed.\n");

// Process line by line.
$HTML_pre = '';
$HTML_table = '';
$prev_cols = array();
foreach ($output as $n => $line) {

	// Skip timings
	if (preg_match('/^(> )?\d+ msec/', $line)) continue;

	// Process items
	elseif (preg_match('/^(> )?(\w) \. (.*)/', $line, $matches)) {

		// Blank line?
		if ($matches[1]) {
			$HTML_table .= '<tr class="separator"><td colspan="100%">&nbsp;</td></td>';
		}

		$HTML_table .= '<tr>';
		$col = 0;
		foreach (explode('=>',$matches[3]) as $i) {
			$i = trim($i);
			if (@$prev_cols[$col] == $i || $i == '[]') {
				$HTML_table .= '<td>&nbsp;</td>';
			} else {
				$HTML_table .= '<td>'.$i.'</td>';
				@$prev_cols[$col] = $i;
			}
			$col++;
		}
		$HTML_table .= '</tr>';
	}

	// Anything else is compiler output
	else
		$HTML_pre .= $line . "\n";

}


// Format into HTML
echo " Formatting to HTML\n";
$HTML = <<<HTML
<html>
<head>
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
	<style type="text/css">
		table { border-collapse:collapse; border-spacing:0; }
		tr:nth-child(odd) { background-color:#eee; }
		tr.separator { background-color:#000; font-size:2px; }
		tr:hover { background-color:skyblue; }
		td { padding:0.2em 1em; border-width:1px 0; border-style:solid; border-color:#ccc; }
		td:last-child { font-style:italic; }
	</style>
</head>
<body>

<a href="#compiler-output">Compiler output</a>

<table>{$HTML_table}</table>

<pre id="compiler-output">{$HTML_pre}</pre>

</body>
</html>
HTML;

// Save to file
echo " Writing to file $outfile\n";
@unlink($outfile);
file_put_contents($outfile, $HTML);
echo " Done\n";
