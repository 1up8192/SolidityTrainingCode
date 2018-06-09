// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import helloworld_artifacts from '../../build/contracts/HelloWorld.json'

// HelloWorld is our usable abstraction, which we'll use through the code below.
var HelloWorld = contract(helloworld_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

function createDataCell(content){
  var cell = document.createElement("td");
  cell.textContent = content;
  return cell;
}

function createHeaderCell(content){
  var cell = document.createElement("th");
  cell.textContent = content;
  return cell;
}

function addDataRow(table, columnList){
  var row = document.createElement("tr");
  columnList.map(createDataCell).forEach((cell) => {
    row.appendChild(cell);
  })
  table.appendChild(row);
}

function addHeaderRow(table, columnHeaderList){
  var row = document.createElement("tr");
  columnHeaderList.map(createHeaderCell).forEach((cell) => {
    row.appendChild(cell);
  })
  table.appendChild(row);
}

function limitRows(table, maxRows){
  if(table.rows.length > maxRows + 1){
    table.deleteRow(1);
  }
}

window.App = {
  start: function() {
    var self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    HelloWorld.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];
      console.log("accounts: ");
      console.log(accounts);

      self.refreshGreeting();
    });
  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  setGreeting: function() {
    var self = this;

    var greeting = document.getElementById("newGreeting").value;
    var helloWorld;
    HelloWorld.deployed().then(function(instance) {
      helloWorld = instance;
      console.log(greeting);
      return helloWorld.setGreeting(greeting, {from: account});
      }).then(function() {
        self.setStatus("Transaction complete!");
        self.refreshGreeting();
      }).catch(function(e) {
        console.log(e);
        self.setStatus("Error; see log.");
      });
  },

  refreshGreeting: function() {
    var self = this;

    var helloWorld;
    HelloWorld.deployed().then(function(instance) {
      helloWorld = instance;
    return helloWorld.greeting.call({from: account});
    }).then(function(value) {
      console.log("greeting: " + value);
      var greeting = document.getElementById("greetingMessage");
      greeting.innerHTML = value.valueOf();
    }).catch(function(e) {
      console.log(e);
      //setStatus("Error; see log.");
    });
  },

  watchEvent: function() {
    var changesTable = document.getElementById("changes")
    addHeaderRow(changesTable, ["Old greeting:", "New Greeting:", "Changer Address:"])

    var helloWorld;
    HelloWorld.deployed().then(function(instance) {
      helloWorld = instance;
      var eventGreetingChanged = helloWorld.greetingChanged();
      var maxRowNum = 10;

      // watch for changes
      eventGreetingChanged.watch(function(error, result){
        // result will contain various information
        // including the argumets given to the Deposit
        // call.
        if (!error){
          var oldGreeting = result.args.oldGreeting.valueOf();
          var newGreeting = result.args.newGreeting.valueOf();
          var changerAddress = result.args.changerAddress.valueOf();
          addDataRow(changesTable, [oldGreeting, newGreeting, changerAddress])
          limitRows(changesTable, maxRowNum);
          //changes.innerHTML = "Old: " + oldGreeting + ", New: " + newGreeting + ", Changer: " + changerAddress;
          console.log(result);
        } else {
          console.log(error);
        }
      });
    });
  }

};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }

  App.start();

  App.watchEvent();

});
