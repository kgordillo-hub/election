pragma solidity 0.5.8;

contract AuditoriaObras {
  
    struct ObraCivil{
    	uint idObra;
    	string nombreObra;
    	uint cantVotosFavor;
        uint cantVotosContra;
        uint cantMinAprobacion;
        string walletContratista;
        string nombreContratista;
        uint256 valorContrato;
        string fechaIniContrato;
        string fechaFinContrato;
    }

    //Guarda las direcciones de los votantes
    mapping(address => mapping( uint => bool)) public voters;
    //Guarda en un arreglo los objetos de obras
    mapping (uint => ObraCivil) public obrasCiviles;
    //variable para contar cantidad de obras civiles
    uint public obrasCivilesCount;

    // Constructor
    constructor () public {
       // se crean las obras civiles
       addObraCivil("Ampliacion hospital Kennedy", 6, "0x6CCCC07477DbC3A3B202ac875085f858C5c8d291", "Odebrech Colombia",0.16 ether, "2017-02-21", "2018-09-10");
       
       addObraCivil("Cinemateca Distrital", 5, "0x826cf91AE5b0ced612c4a3566B7541865D953Df6", "Constructura ACME S.A.", 0.46 ether, "2016-08-02", "2019-06-13");

       addObraCivil("UPA (Unidad Primaria de Atencion) Antonio Nariño", 4, "0x2E5c0B13d1466c1dB9E9438A6A27912D18Be15C9", "Constructura Corrupta S.A.S", 0.12 ether, "2012-08-26", "2014-03-12");
    }

    function addObraCivil(string memory nombreObra, uint cantMinAprobacion,
        string memory walletContratista, string memory nombreContratista,
        uint256 valorContrato, string memory fechaIniContrato, string memory fechaFinContrato) private{
    	
        obrasCivilesCount ++;
    	
        obrasCiviles[obrasCivilesCount] = ObraCivil(obrasCivilesCount, nombreObra, 0,0, cantMinAprobacion, walletContratista, nombreContratista, valorContrato, fechaIniContrato, fechaFinContrato);
    }

    function vote (uint idObra, bool concepto) public {
    	// require that they haven't voted before
    	require(!voters[msg.sender][idObra]);

    	// require a valid candidate
    	require(idObra > 0 && idObra <= obrasCivilesCount);

    	// record that voter has voted
    	voters[msg.sender][idObra] = true;
        //voters[msg.sender] = Voto(msg.sender,idObra,concepto,true);

    	//update candidate vote count
    	if(concepto)
            obrasCiviles[idObra].cantVotosFavor ++;
        else
            obrasCiviles[idObra].cantVotosContra ++;
    	// trigger voted event
    	emit votedEvent(idObra);
    }

    event votedEvent(
    	uint indexed idObra
    );
}