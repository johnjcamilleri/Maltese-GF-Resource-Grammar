# Maltese verb roots in tab-delimited text file format

## About

This folder contains Michael Spagnol's excellent compilation of Maltese verb roots (reference below) as tab-delimited text files.  
The two main output files are:

- [`roots.txt`](https://raw.github.com/johnjcamilleri/Maltese-GF-Resource-Grammar/master/doc/roots/roots.txt)
- [`roots-quad.txt`](https://raw.github.com/johnjcamilleri/Maltese-GF-Resource-Grammar/master/doc/roots/roots-quad.txt)

Everything else is used in the conversion process.
The individual `.csv` files were produced by manually saving each worksheet from the [original XLS file](http://mlrs.research.um.edu.mt/dl/roots.xls) in CSV format, using LibreOffice 3's Calc application.

## Example usage

These files are ideal for `grep`ing (that's what they were made for), and the usual low-level stream base Unix commands. Here's some examples:

### Find all derived forms

Command:

    grep "ċaħad" roots.txt
    
Output:

    ċ-ħ-d	ċaħad	ċaħħad		ċċaħħad		nċaħad		
    
### Find all verbs with a given root

Command:

    grep "ħ-s-l" roots.txt
    
Output:

    ħ-s-l¹	ħasel	ħassel				nħasel			
    ħ-s-l²	ħesel,	ħassel		tħassel					
    ħ-s-l²	ħasel,								
    ħ-s-l²	ħasal								

### List all hollow verbs

Command:

    grep -e "-[wj]-" roots.txt
    
Output:
    
    b-j-d¹		bajjad		tbajjad				bjad	
    b-j-d²	bad,					nbad,			
    b-j-d²	bied					nbied			
    b-j-għ	biegħ					nbiegħ			
    b-j-n		bejjen		tbejjen					
    b-j-t	biet	bejjet		tbejjet,					
    b-j-t				ibbejjet					
    b-w-b		bewweb							
    b-w-ġ		bewweġ,							
    b-w-ġ		bawwax,							
    b-w-ġ		bewwex							
    b-w-għ	*bawa'			tbawwa'					
    b-w-ħ		bewwaħ		tbewwagħ					
    b-w-j	buwa								
    b-w-l	biel	bewwel		*tbewwel					
    b-w-q		bewwaq		tbewwaq					
    b-w-r		bawwar		tbawwar					
    b-w-s	bies	bewwes		tbewwes		nbies,			
    b-w-s						ntbies			
    b-w-t		bewwet							
    ċ-j-ċ	ċieċ								
    ċ-j-k	ċiek								
    ċ-j-m		ċejjem							
    ...
    
### Display neat table

    column -n -t -c 1 -s $'\t' roots.txt
    
### Combine output with table header and format as table

Command:

    (head -n 1 roots.txt ; grep "ħ-.-ġ" roots.txt) | cat | column -n -t -c 1 -s $'\t'
    
Output:

    root         I      II       III  V         VI  VII     VIII    IX     X
    ħ-ġ-ġ¹       *ħaġġ                                              *ħġaġ  
    ħ-ġ-ġ²              ħaġġeġ                                             
    ħ-ġ-ġ³              ħeġġeġ,       tħeġġeġ,                             
    ħ-ġ-ġ³              ħaġġeġ        tħaġġeġ                              
    ħ-l-ġ        ħaleġ  *ħalleġ                     nħaleġ  ħtileġ         
    ħ-m-ġ               ħammeġ        tħammeġ                              
    ħ-r-ġ        ħareġ  ħarreġ        tħarreġ       nħareġ                 stħarreġ,
    ħ-r-ġ                                                                  staħreġ
    ħ-j-ġ/ħ-w-ġ                                     nħtieġ  ħtieġ          

## References

- Spagnol, Michael. 2011. _A Tale of Two Morphologies. Verb structure and argument alternations in Maltese._ Germany: University of Konstanz dissertation.
- [MLRS: Maltese Language Resource Server](http://mlrs.research.um.edu.mt/index.php?page=33)
