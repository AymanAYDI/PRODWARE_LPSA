table 8073320 "PWD Item Jounal Line Buffer"
{
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                                                |
    // | www.prodware.fr                                                                                                                  |
    // +----------------------------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE009.001:GR  05/07/2011 Connector management
    //                              - Create Object
    // 
    // //>>ProdConnect1.6
    // OSYS-Int001.001:GR 18/10/2011 Connector integration
    //                               - Add Fields :   37..51
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD02.001: NI 06/12/2011:  Commentaire sur feuille production
    //                                           - Add field 52
    // 
    // //>>LAP2.01
    // FE_LAPIERRETTE_PROD11.001: GR 14/02/2012: Conform Quality Control
    //                                           - Add field
    //                                             53 Conform Quality Control
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  : - Add Field :   I"s Possible Item" 50000
    //                                             - ADD key :  "Prod. Order No.","Entry Type","Prod. Order Line No."
    // 
    // 
    // //>>LAP2.22
    // P24578_009: RO : 12/12/2019 : cf Demande par mail
    //                   - Add Fields 50001 to 50002
    // 
    // +----------------------------------------------------------------------------------------------------------------------------------+

    Caption = 'Item Journal Line Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(9; "Error Blob"; BLOB)
        {
            Caption = 'Error Blob';
            SubType = Memo;
        }
        field(10; "Connector Values Entry No."; Integer)
        {
            Caption = 'Connector Values Entry No.';
            Editable = false;
        }
        field(11; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            Editable = false;
            TableRelation = "PWD Partner Connector".Code;
        }
        field(12; "Message Code"; Code[20])
        {
            Caption = 'Message Code';
            Editable = false;
            TableRelation = "PWD Connector Messages".Code;
        }
        field(13; Status; Enum "PWD Status Buffer")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(14; Processed; Boolean)
        {
            Caption = 'Processed';
            Editable = false;
        }
        field(15; "Processed Date"; DateTime)
        {
            Caption = 'Processed Date';
            Editable = false;
        }
        field(16; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            Editable = false;
        }
        field(17; "Action"; Option)
        {
            Caption = 'Action';
            OptionCaption = 'Skip,Insert,Modify,Delete';
            OptionMembers = Skip,Insert,Modify,Delete;
        }
        field(18; "RecordID Created"; RecordID)
        {
            Caption = 'RecordID Created';
            Editable = false;
        }
        field(19; "Creation Date"; DateTime)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(20; "Journal Template Name"; Text[30])
        {
            Caption = 'Journal Template Name';
        }
        field(21; "Item No."; Text[30])
        {
            Caption = 'Item No.';
        }
        field(22; "Posting Date"; Text[12])
        {
            Caption = 'Posting Date';
        }
        field(23; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(24; "Document No."; Text[30])
        {
            Caption = 'Document No.';
        }
        field(25; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(26; "Location Code"; Text[30])
        {
            Caption = 'Location Code';
        }
        field(27; Quantity; Text[15])
        {
            Caption = 'Quantity';
        }
        field(28; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Editable = true;
            OptionCaption = ' ,Customer,Vendor,Item';
            OptionMembers = " ",Customer,Vendor,Item;
        }
        field(29; "Journal Batch Name"; Text[30])
        {
            Caption = 'Journal Batch Name';
        }
        field(30; "Reason Code"; Text[30])
        {
            Caption = 'Reason Code';
        }
        field(31; "Unit of Measure Code"; Text[20])
        {
            Caption = 'Unit of Measure Code';
        }
        field(32; "Serial No."; Text[30])
        {
            Caption = 'Serial No.';
        }
        field(33; "Lot No."; Text[30])
        {
            Caption = 'Lot No.';
        }
        field(35; "Expiration Date"; Text[12])
        {
            Caption = 'Expiration Date';
        }
        field(36; "Variant Code"; Text[20])
        {
            Caption = 'Variant Code';
        }
        field(37; "Operation No."; Text[20])
        {
            Caption = 'Operation No.';
        }
        field(38; "Work Center No."; Text[30])
        {
            Caption = 'Work Center No.';
        }
        field(39; "Setup Time"; Decimal)
        {
            Caption = 'Setup Time';
        }
        field(40; "Run Time"; Decimal)
        {
            Caption = 'Run Time';
        }
        field(41; "Output Quantity"; Decimal)
        {
            Caption = 'Output Quantity';
        }
        field(42; "Scrap Quantity"; Decimal)
        {
            Caption = 'Scrap Quantity';
        }
        field(43; "Scrap Code"; Text[30])
        {
            Caption = 'Scrap Code';
        }
        field(44; "Prod. Order No."; Text[30])
        {
            Caption = 'Prod. Order no.';
        }
        field(45; "Document Line No"; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(46; Finished; Boolean)
        {
            Caption = 'Finished';
        }
        field(47; "Auto-Post Document"; Boolean)
        {
            Caption = 'Auto-Post Document';
        }
        field(48; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." WHERE(Status = CONST(Released),
                                                                 "Prod. Order No." = FIELD("Prod. Order No."));
        }
        field(49; "Bin Code"; Text[30])
        {
            Caption = 'Bin Code';
        }
        field(50; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Work Center,Machine Center, ';
            OptionMembers = "Work Center","Machine Center"," ";
        }
        field(51; "No."; Text[30])
        {
            Caption = 'No.';

        }
        field(52; "Comment Code"; Code[10])
        {
            Description = 'LAP1.00';
        }
        field(53; "Conform quality control"; Boolean)
        {
            Caption = 'Conform quality control';
            Description = 'LAP1.00';
        }
        field(50000; "Is Possible Item"; Boolean)
        {
            Caption = 'Is Possible Item';
            Description = 'LAP2.06';
        }
        field(50001; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'LAP2.22';
        }
        field(50002; "New Location Code"; Code[10])
        {
            Caption = 'New Location Code';
            Description = 'LAP2.22';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Prod. Order No.", "Entry Type", "Prod. Order Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CduLBufferManagement: Codeunit "PWD Buffer Management";
    begin
        CduLBufferManagement.FctDeleteBufferLine(DATABASE::"PWD PEB Item Jnl Line Buffer", "Entry No.");
        CduLBufferManagement.FctDeleteBufferLine(DATABASE::"PWD WMS Item Jnl Line Buffer", "Entry No.");
    end;
}

