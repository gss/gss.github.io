# grunt-combine

Token based search and replace functionality for [grunt](https://github.com/gruntjs/grunt/).

### Install

	$ npm install grunt-combine [-g]

### Use

	grunt.config({
		combine:{
			single:{
				input:"./input.js",
				output:"./output.js",
				tokens:[{
					token:"$1",
					file:"./file.js"
				},{
					token:"%2",
					string:"replacement string"
				},{
					token:"!3",
					file:"./file.txt"
				}]
			},
			multiple:{
				input:["./input1.js", "./input2.js"],
				output:"output/",
				tokens:[{
					token:"$1",
					file:"./file.js"
				}]
			}
		}
	});

	grunt.loadNpmTask("grunt-combine");

	grunt.registerTask("default",["combine:single", "combine:multiple"]);

### Options

* `input`  - *{ String/Array }* Single file or Array of files containing the referenced tokens.
* `output` - *{ String }* The file or directory (if dealing with multiple inputs) that the task will output after completing.
* `tokens` - *{ Array }* Tokens to search for and replace with either a string or a file's contents.
	* `token`  - *{ String }* The string that will be searched for in the file.
	* `file`   - *{ String }* The file thats contents will replace the `token`
	* `string` - *{ String }* The string that will replace the `token`
