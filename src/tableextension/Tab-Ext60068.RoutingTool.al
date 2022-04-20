tableextension 60068 "PWD RoutingTool" extends "Routing Tool"
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

        modify("No.")
        {
            TableRelation = IF ("PWD Type" = FILTER(Method)) "PWD Tools Instructions"."No." WHERE(Type = FILTER(Method))
            ELSE
            IF ("PWD Type" = FILTER(Quality)) "PWD Tools Instructions"."No." WHERE(Type = FILTER(Quality))
            ELSE
            IF ("PWD Type" = FILTER(Plan)) "PWD Tools Instructions"."No." WHERE(Type = FILTER(Plan))
            ELSE
            IF ("PWD Type" = FILTER(Zone)) "PWD Tools Instructions"."No." WHERE(Type = FILTER(Zone))
            ELSE
            IF ("PWD Type" = FILTER("Targeted dimension")) "PWD Tools Instructions"."No." WHERE(Type = FILTER("Targeted dimension"))
            ELSE
            IF ("PWD Type" = FILTER(Item)) Item."No.";
        }
    }
    keys
    {
        //TODO: clé contient champ standard
        // key(Key2; "PWD Type", "No.")
        // {
        // }
    }
}
