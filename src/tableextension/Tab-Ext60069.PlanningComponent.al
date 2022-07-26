tableextension 60069 "PWD PlanningComponent" extends "Planning Component"
{
    // <changelog>
    //   <add id="CH1390" dev="SRYSER" request="CH-START-370" date="2004-02-25" area="SWS39"
    //   releaseversion="CH3.70A">Field 12 Size 30 -> 50</add>
    // </changelog>
    // 
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add fields 50000..50005
    // 
    // FE_PROD01.001:GR 14/02/2012:  Order No, OF and LOT
    //                               - modify fct TransferFromComponent
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Original Source Id"; Integer)
        {
            Caption = 'Original Source Id';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50001; "PWD Original Source No."; Code[20])
        {
            Caption = 'Original Source No.';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50002; "PWD Original Source Position"; Integer)
        {
            Caption = 'Original Source Position';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50003; "PWD Original Counter"; Integer)
        {
            Caption = 'Original Counter';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50004; "PWD Transmitted Order No."; Boolean)
        {
            Caption = 'Transmitted Order No.';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50005; "PWD Lot Determining"; Boolean)
        {
            Caption = 'Lot Determining';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Item: Record Item;
                POPlanningComp: Record "Planning Component";
                gctxCfm0001: Label 'Set %1 = %2 at all other concerned lines?';
                gctxErr0001: Label '%1: Component %2 is already set to %3.';
            begin
                IF "PWD Lot Determining" THEN BEGIN
                    Item.GET("Item No.");
                    Item.IsLotItem(/*piForceError=*/ TRUE);
                    //TESTFIELD("From the same Lot", TRUE);
                END;

                POPlanningComp.SETRANGE("Worksheet Template Name", "Worksheet Template Name");
                POPlanningComp.SETRANGE("Worksheet Batch Name", "Worksheet Batch Name");
                POPlanningComp.SETRANGE("Worksheet Line No.", "Worksheet Line No.");
                POPlanningComp.SETFILTER("Line No.", '<>%1', "Line No.");
                IF "PWD Lot Determining" THEN BEGIN
                    POPlanningComp.SETFILTER("Item No.", '<>%1', "Item No.");
                    POPlanningComp.SETRANGE("PWD Lot Determining", TRUE);
                    IF POPlanningComp.FIND('-') THEN
                        ERROR(gctxErr0001, POPlanningComp.FIELDCAPTION("PWD Lot Determining"), POPlanningComp."Item No.", "PWD Lot Determining");
                END;

                POPlanningComp.SETRANGE("Item No.", "Item No.");
                POPlanningComp.SETRANGE("PWD Lot Determining", (NOT "PWD Lot Determining"));
                IF POPlanningComp.FIND('-') THEN
                    IF CONFIRM(gctxCfm0001, TRUE, POPlanningComp.FIELDCAPTION("PWD Lot Determining"), "PWD Lot Determining") THEN
                        POPlanningComp.MODIFYALL("PWD Lot Determining", "PWD Lot Determining")
                    ELSE
                        ERROR('');

            end;
        }
    }
}
