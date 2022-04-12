tableextension 60040 "PWD ProdOrderRoutingTool" extends "Prod. Order Routing Tool"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 12/07/2017 : FICHE SUIVEUSE - PP 1
    //                   - Add Fields 50000 - Type - Option
    //                                50001 - Criteria - Text50
    //                   - Modif Property TableRelation For Field 4
    //                   - Add C/AL Local and C/AL Code in trigger No. - OnValidate()
    //                   - Change property Editable = No for Field Description
    //                   - Add Key Type,No.
    fields
    {
        field(50000; "PWD Type"; Option)
        {
            Caption = 'Type';
            Description = 'LAP2.12';
            OptionCaption = 'Method,Quality,Plan,Zone,Targeted dimension,Item';
            OptionMembers = Method,Quality,Plan,Zone,"Targeted dimension",Item;
        }
        field(50001; "PWD Criteria"; Text[50])
        {
            Caption = 'Criteria';
            Description = 'LAP2.12';
        }
    }
    keys
    {
        //TODO  // key(Key50000; "PWD Type", "No.")
        // {
        // }
    }
}

