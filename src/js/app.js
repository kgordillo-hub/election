window.addEventListener('load', async () => {
    // Modern dapp browsers...
    if (window.ethereum) {
        window.web3 = new Web3(ethereum);
        try {
            // Request account access if needed
            await ethereum.enable();
            App.init();       
            
        } catch (error) {
            // User denied account access...
            console.log(error);
        }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
        window.web3 = new Web3(web3.currentProvider);
        // Acccounts always exposed
         App.init();
        

    }
    // Non-dapp browsers...
    else {
        console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
    }
});


App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("AuditoriaObras.json", function(election) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.AuditoriaObras = TruffleContract(election);
      // Connect provider to interact with contract
      App.contracts.AuditoriaObras.setProvider(App.web3Provider);
      //Init event listener
      App.listenForEvents();

      return App.render();
    });
  },

  render: function() {
  var electionInstance;
  var loader = $("#loader");
  var content = $("#content");

  loader.show();
  content.hide();

  // Load account data
  web3.eth.getCoinbase(function(err, account) {
    if (err === null) {
      App.account = account;
      $("#accountAddress").html("Your Account: " + account);
    }
  });

  // Load contract data
  App.contracts.AuditoriaObras.deployed().then(function(instance) {
    electionInstance = instance;
    return electionInstance.obrasCivilesCount();
  }).then(function(obrasCivilesCount) {
    var candidatesResults = $("#candidatesResults");
    candidatesResults.empty();
    $("#candidatesResults tr").remove();
    var candidatesSelect = $('#candidatesSelect');
    candidatesSelect.empty();

    for (var i = 1; i <= obrasCivilesCount; i++) {
      electionInstance.obrasCiviles(i).then(function(obraCivil) {
        var id = obraCivil[0];
        var name = obraCivil[1];
        var voteCountPos = obraCivil[2];
        var voteCountNeg = obraCivil[3];
        var voteRequired = obraCivil[4];
        var walletContra = obraCivil[5];
        var nameContra = obraCivil[6];
        var valorContrato = obraCivil[7]/Math.pow(10,18);
        var fechaIni = obraCivil[8];
        var fechaFin = obraCivil[9];

        // Render obraCivil Result
        var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + nameContra + "</td><td>"+voteCountPos+"</td><td>"+voteCountNeg+"</td><td>"+voteRequired+"</td><td>"+valorContrato+"</td><td>"+fechaIni+"</td><td>"+fechaFin+"</td></tr>"
        candidatesResults.append(candidateTemplate);
        
        electionInstance.voters(App.account,id).then(function(hasVoted){
          //console.log(hasVoted);
          if(!hasVoted){
            var candidateOption = "<option value='" + id + "' >" + name + "</ option>"
            candidatesSelect.append(candidateOption);
          }
        }
        );
       
        loader.hide();
        content.show();
      });
    }
    //return electionInstance.voters(App.account);
  })/*.then(function(votante) {
    // Do not allow a user to vote
    //if(votante) {
     // $('form').hide();
    //}
    loader.hide();
    content.show();
  })*/
  .catch(function(error) {
    console.warn(error);
  });
},
 castVote: function() {
    var candidateId = $('#candidatesSelect').val();
    App.contracts.AuditoriaObras.deployed().then(function(instance) {
      return instance.vote(candidateId, true,{ from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  },

  listenForEvents: function() {
  App.contracts.AuditoriaObras.deployed().then(function(instance) {
    instance.votedEvent({}, {
      fromBlock: 0,
      toBlock: 'latest'
    }).watch(function(error, event) {
      console.log("event triggered", event)
      // Reload when a new vote is recorded
      App.render();
    });
  });
}

};

/*$(function() {
  $(window).load(function() {
    App.init();
  });
});*/