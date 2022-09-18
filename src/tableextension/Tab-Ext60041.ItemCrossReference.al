tableextension 60041 "PWD ItemCrossReference" extends "Item Cross Reference"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // PWA.001:GR 23/05/2011   Connector integration
    //                         - Add field 8073282 "EAN13"
    // 
    // //>>LPSA.TDL
    // LPSA.TDL.09/02/2015 : Add Field 50000, 50001
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 17/10/2017 : DEMANDES DIVERSES
    //                   - Change Length for Field 50000
    // 
    // //>>LAP2.16
    // P24578_004 : RO : 27/03/2018 : DEMANDES DIVERSES
    //                   - Add Field 50003 - Item Search Description - Code30
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD Customer Plan No."; Text[100])
        {
            Caption = 'Customer Plan No.';
            Description = 'LPSA.TDL.09/02/2015';
            DataClassification = CustomerContent;
        }
        field(50001; "PWD Customer Plan Description"; Text[50])
        {
            Caption = 'Customer Plan Description';
            Description = 'LPSA.TDL.09/02/2015';
            DataClassification = CustomerContent;
        }
        field(50002; "PWD Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Cross-Reference Type No.")));
            Caption = 'Client';
            FieldClass = FlowField;
        }
        field(50003; "PWD Item Search Description"; Code[100])
        {
            CalcFormula = Lookup(Item."Search Description" WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Search Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8073282; "PWD EAN13"; Code[13])
        {
            caption = 'EAN13';
            DataClassification = CustomerContent;
        }
    }
}

