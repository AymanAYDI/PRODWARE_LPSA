tableextension 60027 "PWD InventorySetup" extends "Inventory Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 20/06/2017 :  CONFIGURATEUR ARTICLES
    //                - Add Fields 50010 - Product Group Code  Dimension - Code10
    //                             50011 - LPSA Customer No. - Code20
    //                             50012 - STRATEGY Customer No. - Code20
    //                             50013 - Item Filter For Extern Ref - Code250
    // 
    // //>>LAP2.19
    // P24578_008.001 : LY 12/08/2019 : Export contrôle de gestion
    fields
    {
        field(50000; "PWD Item Filter Level 1"; Text[100])
        {
            Caption = 'Item Filter Level 1';
        }
        field(50001; "PWD Item Filter Level 2"; Text[100])
        {
            Caption = 'Item Filter Level 2';
        }
        field(50002; "PWD Item Filter Level 3"; Text[100])
        {
            Caption = 'Item Filter Level 3';
        }
        field(50003; "PWD Item Filter Level 4"; Text[100])
        {
            Caption = 'Item Filter Level 4';
        }
        field(50010; "PWD Product Group Code Dim"; Code[20])
        {
            Caption = 'Product Group Code  Dimension';
            Description = 'LAP2.12';
            TableRelation = Dimension;
        }
        field(50011; "PWD LPSA Customer No."; Code[20])
        {
            Caption = 'N° Client LPSA';
            Description = 'LAP2.12';
            TableRelation = Customer;
        }
        field(50012; "PWD STRATEGY Customer No."; Code[20])
        {
            Caption = 'N° Client STRATEGIE';
            Description = 'LAP2.12';
            TableRelation = Customer;
        }
        field(50013; "PWD Item Filter For Extern Ref"; Code[250])
        {
            Caption = 'Filtrage Article pour la création des références externes';
            Description = 'LAP2.12';
        }
        field(50020; "PWD Item Category Dimension"; Code[20])
        {
            Caption = 'Item Category Dimension';
            Description = 'LAP2.19';
            TableRelation = Dimension;
        }
        field(50021; "PWD Product Group Dimension"; Code[20])
        {
            Caption = 'Product Group Dimension';
            Description = 'LAP2.19';
            TableRelation = Dimension;
        }
        field(50022; "PWD Closing Export DateFormula"; DateFormula)
        {
            Caption = 'Closing File Export Date Formula';
            Description = 'LAP2.19';
        }
        field(50023; "PWD Path for Closing Export"; Text[250])
        {
            Caption = 'Path for Closing Export';
            Description = 'LAP2.19';

            trigger OnValidate()
            var
                CduLClosingMgt: Codeunit "PWD Closing Management";
            //"-LAP2.19-": Integer;
            begin
                //>>P24578_008.001
                "PWD Path for Closing Export" := CduLClosingMgt.GetDirectory("PWD Path for Closing Export");
                //<<P24578_008.001
            end;
        }
        field(50024; "PWD Closing Sendor E-Mail"; Text[100])
        {
            Caption = 'Closing Sendor E-Mail';
            Description = 'LAP2.19';
            ExtendedDatatype = EMail;
        }
        field(50025; "PWD Recipient User ID"; Code[20])
        {
            Caption = 'Recipient User ID';
            Description = 'LAP2.19';
            TableRelation = "User Setup";
        }
        field(50026; "PWD Period for Inventory Cover"; Integer)
        {
            Caption = 'Period for the calculation of the stock cover (in Months)';
            Description = 'LAP2.19';
        }
    }
}

