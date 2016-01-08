/**
 * dv - is a tool that allows me to alias projects that I'm currently working on
 * Here is some exmaples of usage:
 *
 * //Take you to ~/Development
 * * dv
 *
 * //add alfanweb to aliases and configure it to go to ~/Development/alfan/website
 * * dv alias alfanweb ~/Development/alfan/website
 *
 * //take me to ~/Development/alfan/website
 * * dv alfanweb
 *
 * //add thisproj to aliases and configure it to go to current directory
 * * dv alias thisproj .
 */

var fs = require('fs');
var path = require('path');

var ALIAS_FILEPATH = path.join(process.env.HOME, '/.devAlias.json');
var DELIMETER = '>';
var NEW_LINE = ',;';
var CMD_CD = 'cd';
var CMD_TXT = 'txt';
var ERR_INVLD_ARG_NUM = 'invalid number of arguments';

// console.log('from path: ' + process.cwd());
// console.log('settings path: ' + ALIAS_FILEPATH);
// console.log(data.aliases.default);

var data = fetchAliasData();

if        (process.argv.length <= 2) {              //2 = node dv
  cdToDefault();
} else {

  // argv indexes: node dv [2] [3] [4] [5]

  switch (process.argv[2]) {
    case 'list':
    case 'ls':
      list();
      break;
    case 'alias':
      if (process.argv.length < 4)    errorReq(ERR_INVLD_ARG_NUM);
      alias(process.argv[3], process.argv[4]);
      break;
    case 'unalias':
      if (process.argv.length < 4)    errorReq(ERR_INVLD_ARG_NUM);
      unalias(process.argv[3]);
      break;
    default:
      if (!hasAlias(process.argv[2])) errorReq(process.argv[2] + ' command not found');
      cdToAlias(process.argv[2]);
  }
}

function hasAlias(alias){
  return data.aliases[alias] !== undefined;
}

function alias(alias, path) {

  if (alias == 'ls') errorReq('ls is a reserved word');

  if (path == '.' || path === undefined)    path = process.cwd();

  var msg = '';
  var isNew = data.aliases[alias] === undefined;

  if (!isNew) {
    msg  = alias + ' has been updated from: ' + data.aliases[alias] + NEW_LINE;
    msg += 'to: ' + path;
  } else {
    msg = alias + ' has been set to: ' + path;
  }

  data.aliases[alias] = path;
  persistData();

  successReq(CMD_TXT, msg);
}

function unalias(alias) {
  var msg = '';

  if (alias == 'default') errorReq('\"default\" is reserved and is unsettable');

  var exists = data.aliases[alias] !== undefined;

  if (exists) {
    msg  = alias + ' has been removed. ' + NEW_LINE;
    msg += 'you can re alias it using this command: ' + NEW_LINE;
    msg += 'dv alias ' + alias + ' ' + data.aliases[alias];
  }else{
    msg  = alias + ' is not a registered alias';
  }

  delete data.aliases[alias];
  persistData();

  successReq(CMD_TXT, msg);
}

function list () {
  var result = '';

  Object.keys(data.aliases).forEach(function(key) {
      result += key + ':\t' + data.aliases[key] + NEW_LINE;
  });

  successReq(CMD_TXT, result);
}

function cdTo(path) {
  successReq(CMD_CD, path);
}

function cdToAlias(alias) {
  cdTo(data.aliases[alias]);
}

function cdToDefault() {
  cdTo(data.aliases.default);
}

function fetchAliasData() {
  var result = fs.readFileSync(ALIAS_FILEPATH, 'utf8');

  try {
    result = JSON.parse(result);
  } catch (e) {
    errorReq(ALIAS_FILEPATH + ' is corrupt');
  }

  return result;
}

function initConfigFile() {
  //Should have an init function for first time runs
}

function persistData() {
  var stringified = JSON.stringify(data, null, 4);
  fs.writeFileSync(ALIAS_FILEPATH, stringified , 'utf-8');
}

function errorReq(error) {
  console.error('error: ' + error);
  process.exit(1);
}

function successReq(cmd, data) {
  console.log(cmd + DELIMETER + data);
  process.exit();
}
