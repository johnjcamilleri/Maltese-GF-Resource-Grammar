#!/usr/bin/php
<?php

// Just some variables
$outfile = 'test/nouns.out';
$command = './_gf < test/nouns.gfs > '.$outfile;
$htmlfile = 'test/nouns.out.html';

// Execute GF stuff and capture output
echo " Running GF\n";
chdir( dirname(__FILE__) . '/../' );
exec($command, $out, $return_status);
if ($return_status != 0)
	die (" Failed.\n");
$output = file($outfile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

// Process line by line.
$HTML_console = '';
$HTML_table = '';
$TEXT = '';
$prev_cols = array();
foreach ($output as $n => $line) {

	// Skip timings
	if (preg_match('/^(> )?\d+ msec/', $line)) continue;

	// Process items
	elseif (preg_match('/^(> )?(\w) \. (.*)/', $line, $matches)) {

		// Have we reached a new entry?
		if ($matches[1]) {
			$HTML_table .= '<tr class="separator"><td colspan="100%">&nbsp;</td></td>';
			$TEXT .= "\n<hr/>\n";
		}

		$columns = explode('=>',$matches[3]);

		array_walk(
			$columns,
			create_function('$v,$k,&$t','$t .= ($k==3) ? "<em>$v</em>" : str_pad($v, 20);'),
			&$TEXT
		);
		$TEXT .= "\n";

		$HTML_table .= '<tr>';
		$col = 0;
		foreach ($columns as $i) {
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
		$HTML_console .= $line . "\n";

}


// Format into HTML
echo " Formatting to HTML\n";
$HTML = <<<HTML
<html>
<head>
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
	<style type="text/css">
		#text-output { white-space:pre; font-family:monospace; }
		#text-output em { font-family:serif; }
		table { border-collapse:collapse; border-spacing:0; }
		tr:nth-child(odd) { background-color:#eee; }
		tr.separator { background-color:#000; font-size:2px; }
		td { padding:0.2em 1em; border-width:1px 0; border-style:solid; border-color:#ccc; }
		td:last-child { font-style:italic; }
	</style>
</head>
<body>

<a href="#compiler-output">Compiler output</a>

<div id="text-output">
{$TEXT}
</div>

<pre id="compiler-output">{$HTML_console}</pre>

</body>
</html>
HTML;


//<table>{$HTML_table}</table>


// Save to file
echo " Writing to file $htmlfile\n";
@unlink($htmlfile);
file_put_contents($htmlfile, $HTML);
echo " Done\n";
