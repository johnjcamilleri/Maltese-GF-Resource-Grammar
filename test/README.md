# Description of the `test` directory

## The process

As detailed in the GF Book, the test cycle works as follows:

1. Create a `*.trees` file which contains only trees (and comments) which you want to test for linearisation.
2. Linearise them and save the output to file with a command like: `rf -lines -tree -file=test/nouns.trees | l -table | wf -file=nouns.out`
3. Create a gold standard by going through the output and correcting it manually, then save it as `nouns.gold`.
4. Each time you update your grammar, re-run step 2. Then compare the new output with your gold standard with `diff` or some other tool.

## The `run.php` script

I created this small script to automate the tasks above. It should be run from _above_ the `test` directory:

    maltese$ php test/run.php type [--generate] [--cached]

where:

- `type` is the name of your trees file without the extension, e.g. `nouns`.
- Use the `--generate` flag to save your gold standard file (which you should then correct manually).
- Use the `--cached` flag to _not_ run GF, but simply use use the output from the last time you run the tool.

The tool will create a `*.html` file with color-coded comparisons of the output against the gold standard, along with some nice statistics.

