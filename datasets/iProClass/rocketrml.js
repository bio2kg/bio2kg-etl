const parser = require('rocketrml');

const doMapping = async () => {
  const options = {
    toRDF: true,
    verbose: true,
    xmlPerformanceMode: false,
    replace: false,
  };
  const result = await parser.parseFile('./data/mapping.rml.ttl', './data/bio2kg-rocketml.n3', options).catch((err) => { console.log(err); });
  console.log(result);
};

doMapping();

// node rocketrml.js