const parser = require('rocketrml');

const doMapping = async () => {

    const args = process.argv.slice(2);
    const mapping_path = args[0] || './data/mapping.rml.ttl'
    const output_path = args[1] || './data/bio2kg-rocketml.n3';

    const options = {
        verbose: false,
        toRDF: true,
        // If you want to insert your all objects with their regarding @id's (to get a nesting in jsonld), "Un-flatten" jsonld
        replace: false,
        
        // You can delete namespaces to make the xpath simpler.
        // removeNameSpace: {xmlns:"https://xmlnamespace.xml"},
        // Choose xpath evaluator library, available options: pugixml (cpp xpath implementation, previously xmlPerformanceMode:true) | fontoxpath (xpath 3.1 engine) | default | xpath (same as default)
        xpathLib: "pugixml",
        // xmlPerformanceMode: true,
        // ignore input values that are empty string (or whitespace only) (only use a value from the input if value.trim() !== '') (default false)
        ignoreEmptyStrings: true,

        // You can also use functions to manipulate the data while parsing. (E.g. Change a date to a ISO format, ..)
        functions : {
            'http://users.ugent.be/~bjdmeest/function/grel.ttl#createDescription': function (data) {
                let result=data[0]+' is '+data[1]+ ' years old.'; 
                return result;
            }
        }
        // https://github.com/semantifyit/RocketRML
    };
    const result = await parser.parseFile(mapping_path, output_path, options).catch((err) => { console.log(err); });
    console.log(result);
};


doMapping();

// node rocketrml.js