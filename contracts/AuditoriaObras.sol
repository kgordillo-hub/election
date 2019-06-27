pragma solidity 0.5.8;

contract AuditoriaObras {
  
    struct ObraCivil{
    	uint idObra;
    	string nombreObra;
    	uint cantVotosFavor;
        uint cantVotosContra;
        uint cantMinAprobacion;
        address walletContratista;
        string nombreContratista;
        uint256 valorContrato;
        string fechaIniContrato;
        string fechaFinContrato;
        bool contratoPagado;
    }

    //Guarda las direcciones de los votantes
    mapping(address => mapping( uint => bool)) public voters;
    //Guarda en un arreglo los objetos de obras
    mapping (uint => ObraCivil) public obrasCiviles;
    //variable para contar cantidad de obras civiles
    uint public obrasCivilesCount;

    // Constructor
    constructor () public {
        string memory wallet1 = "0x3D84dF4A174Be9e7813F4A4664B19fF56386F8B7";//"0x6CCCC07477DbC3A3B202ac875085f858C5c8d291"
       // se crean las obras civiles
       addObraCivil("Ampliacion hospital Kennedy", 2, parseAddr("0x3D84dF4A174Be9e7813F4A4664B19fF56386F8B7"), "Odebrech Colombia",0.52 ether, "2017-02-21", "2018-09-10");
       
       addObraCivil("Cinemateca Distrital", 5, parseAddr("0x826cf91AE5b0ced612c4a3566B7541865D953Df6"), "Constructura ACME S.A.", 0.46 ether, "2016-08-02", "2019-06-13");

       addObraCivil("UPA (Unidad Primaria de Atencion) Antonio Nariño", 4, parseAddr("0x2E5c0B13d1466c1dB9E9438A6A27912D18Be15C9"), "Constructura Corrupta S.A.S", 0.39 ether, "2012-08-26", "2014-03-12");
    }

    function addObraCivil(string memory nombreObra, uint cantMinAprobacion,
        address walletContratista, string memory nombreContratista,
        uint256 valorContrato, string memory fechaIniContrato, string memory fechaFinContrato) private{
    	
        obrasCivilesCount ++;
    	
        obrasCiviles[obrasCivilesCount] = ObraCivil(obrasCivilesCount, nombreObra, 0,0, cantMinAprobacion, walletContratista, nombreContratista, valorContrato, fechaIniContrato, fechaFinContrato,false);
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
        if(idObra > 0 && idObra <= obrasCivilesCount)
    	   emit votedEvent(idObra);

        if(obrasCiviles[idObra].cantVotosFavor >= obrasCiviles[idObra].cantMinAprobacion && !obrasCiviles[idObra].contratoPagado)
            {   pagarContrato(idObra);
                obrasCiviles[idObra].contratoPagado=true;
            }
    }

    function pagarContrato(uint id) public{
        address payable cuentaPagar = address(uint160(obrasCiviles[id].walletContratista));
        cuentaPagar.transfer(obrasCiviles[id].valorContrato);
    }

    function() external payable { }

    function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
    bytes memory tmp = bytes(_a);
    uint160 iaddr = 0;
    uint160 b1;
    uint160 b2;
    for (uint i = 2; i < 2 + 2 * 20; i += 2) {
        iaddr *= 256;
        b1 = uint160(uint8(tmp[i]));
        b2 = uint160(uint8(tmp[i + 1]));
        if ((b1 >= 97) && (b1 <= 102)) {
            b1 -= 87;
        } else if ((b1 >= 65) && (b1 <= 70)) {
            b1 -= 55;
        } else if ((b1 >= 48) && (b1 <= 57)) {
            b1 -= 48;
        }
        if ((b2 >= 97) && (b2 <= 102)) {
            b2 -= 87;
        } else if ((b2 >= 65) && (b2 <= 70)) {
            b2 -= 55;
        } else if ((b2 >= 48) && (b2 <= 57)) {
            b2 -= 48;
        }
        iaddr += (b1 * 16 + b2);
    }
    return address(iaddr);
}

    event votedEvent(
    	uint indexed idObra
    );
}