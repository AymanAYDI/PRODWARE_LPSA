tableextension 60064 "PWD MachineCenter" extends "Machine Center"
{
    // <changelog>
    //   <add id="CH1341" dev="SRYSER" request="CH-START-400A-SWS34" date="2005-06-30" area="SWS34"
    //     releaseversion="CH4.00A">
    //     Added Post Code Feature
    //   </add>
    // </changelog>
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 21/10/2011   Connector integration
    //                                   - Add  field : Type
    // 
    // 
    // //PLAW11.0
    // FE_Merge: TO 23/01/2012:  Merge of pbjects Planner One
    //                                           - Add field 8076501
    // 
    // TDL.NAV : Suivi avancement sur Excel.
    //                                           - Add field 50000,50010,50020
    // +----------------------------------------------------------------------------------------------------------------+
    // PLAW1 -----------------------------------------------------------------------------
    // PLAW11-4.0   06/02/2014 PO-3706 add parameters
    // PLAW1 -----------------------------------------------------------------------------
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 27/04/2017 : FICHE SUIVEUSE - PP 1
    //                   - Add Field 50030 - To Exclure In Tracking Card - Boolean
    fields
    {
        field(50000; "PWD Planning"; Boolean)
        {
            Caption = 'Excel Planning';
        }
        field(50010; "PWD Planning Order No."; Integer)
        {
            Caption = 'N° Order Planning Excel';
        }
        field(50020; "PWD Planning Status Name"; Text[30])
        {
            Caption = 'Nom Statut Planning Excel';
        }
        field(50030; "PWD To Excl. In Tracking Card"; Boolean)
        {
            Caption = 'To Exclure In Tracking Card';
            Description = 'LAP2.12';
        }
        field(8073282; "PWD Type"; Option)
        {
            Caption = 'Type';
            Description = 'ProdConnect1.6';
            OptionCaption = 'Machine,Labor';
            OptionMembers = Machine,Manpower;
        }
    }
}
