codeunit 8073308 "PWD Buffers Process Batch"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.07.01
    // WMS-EBL1-003.001.001:GR 04/01/2012   Connector integration
    //                                      - Create Object
    // 
    // 
    // //>>LAP2.06
    // FE_LAPRIERRETTE_GP0004.001 :GR  23/05/13  : - C\AL inOnRun()
    // 
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    var
        CduLBufferManagement: Codeunit "PWD Buffer Management";
        FieldLRef: FieldRef;
        RecLItemJounalLineBuffer: Record "PWD Item Jounal Line Buffer";
    begin
        Clear(CduLBufferManagement);
        Clear(FieldLRef);

        //>>FE_LAPRIERRETTE_GP0004.001
        if (RecGRef.Number = DATABASE::"PWD Item Jounal Line Buffer") then begin
            RecLItemJounalLineBuffer.SetCurrentKey("Prod. Order No.", "Entry Type", "Prod. Order Line No.");
            RecGRef.SetView(RecLItemJounalLineBuffer.GetView())
        end;
        //<<FE_LAPRIERRETTE_GP0004.001

        FieldLRef := RecGRef.Field(14);
        FieldLRef.SetRange(false);
        FieldLRef := RecGRef.Field(17);
        FieldLRef.SetFilter('>0');  //0=Skip
        CduLBufferManagement.FctHideDialog(true);
        CduLBufferManagement.FctMultiProcessLine(RecGRef);
    end;

    var
        RecGRef: RecordRef;


    procedure FctInit(RecLRef: RecordRef)
    begin
        Clear(RecGRef);
        RecGRef := RecLRef;
    end;
}

