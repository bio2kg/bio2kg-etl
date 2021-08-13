const parser = require('rocketrml');
const yargs = require('yargs/yargs')
const { hideBin } = require('yargs/helpers')

// Parse args
const args = yargs(hideBin(process.argv))
  .option('mapping', {
    alias: 'm',
    type: 'string',
    description: 'Path to the mapping file'
  })
  .option('output', {
    alias: 'o',
    type: 'string',
    description: 'Path to the output file'
  })
  .option('verbose', {
    alias: 'v',
    type: 'boolean',
    description: 'Run with verbose logging',
    default: false
  })
  .alias('help', 'h')
  .argv

// https://github.com/semantifyit/RocketRML
// Install custom RocketRML from GitHub:
// yarn add vemonet/RocketRML#add-yarrrml
// Or install from a local folder to develop RocketRML:
// yarn add file:$HOME/sandbox/RocketRML
// And update when change
// yarn upgrade file:$HOME/sandbox/RocketRML

const doMapping = async () => {
    const mapping_path = args.mapping || './data/mapping.rml.ttl'
    const output_path = args.output || './data/bio2kg-rocketml.ttl';

    const options = {
        verbose: args.verbose,
        toRDF: true,
        // If you want to insert your all objects with their regarding @id's (to get a nesting in jsonld), "Un-flatten" jsonld
        replace: false,
        
        // You can delete namespaces to make the xpath simpler.
        // removeNameSpace: {xmlns:"https://xmlnamespace.xml"},
        // Choose xpath evaluator library, available options: pugixml (cpp xpath implementation, previously xmlPerformanceMode:true) 
        // fontoxpath (xpath 3.1 engine) | default | xpath (same as default)
        xpathLib: "pugixml",
        // xmlPerformanceMode: true,
        // ignore input values that are empty string (or whitespace only) (only use a value from the input if value.trim() !== '') (default false)
        ignoreEmptyStrings: true,

        // Define functions available in RML mapper
        functions : {
            'https://w3id.org/um/ids/rmlfunctions.ttl#string_process': function (data) {
                const idfs = 'https://w3id.org/um/ids/rmlfunctions.ttl#'
                // console.log(data);
                s = String(data[idfs + 'input']) || null
                split = data[idfs + 'split_on'] || null
                prefix = data[idfs + 'add_prefix'] || null
                find = data[idfs + 'find'] || null
                replace = data[idfs + 'replace'] || null
                format = data[idfs + 'format_for'] || null
                
                if(!s) {
                    return undefined;
                }
                
                resultList = [];
                if(split) {
                    resultList = s.split(split);
                } else {
                    resultList.push(s);
                }
                
                if(prefix || replace || format) {
                    resultList.forEach(function (value, i) {
                        if(format && format.toLowerCase() == "uri") { 
                            resultList[i] = resultList[i].replace(/ /g, "-")
                                    .replace(/,/g, "-").replace(/\./g, "-").toLowerCase();
                        }
                        if(format && format.toLowerCase() == "lowercase") {
                            resultList[i] = resultList[i].toLowerCase();
                        }
                        if(format && format.toLowerCase() == "uppercase") {
                            resultList[i] = resultList[i].toUpperCase();
                        }
                        if(prefix) { 
                            resultList[i] = prefix + resultList[i];
                        }
                        if(find && replace) { 
                            // resultList[i] = resultList[i].replaceAll(find, replace);
                            resultList[i] = resultList[i].replace(new RegExp(find, 'g'), replace);
                        }
                    });
                }
                return resultList;
            }
        }
    };
    // console.log(mapping_path);
    const result = await parser.parseFile(mapping_path, output_path, options).catch((err) => { console.log(err); });
};

doMapping();

// node ../rocketrml.js