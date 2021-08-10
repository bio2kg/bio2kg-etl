const parser = require('rocketrml');

const doMapping = async () => {
  const options = {
    toRDF: true,
    verbose: true,
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
    // functions : {**See the Functions section**}
    // https://github.com/semantifyit/RocketRML
  };
  const result = await parser.parseFile('./data/mapping.rml.ttl', './data/bio2kg-rocketml.n3', options).catch((err) => { console.log(err); });
  console.log(result);
};


doMapping();

// node rocketrml.js