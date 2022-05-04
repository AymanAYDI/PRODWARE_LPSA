codeunit 8073309 "Buffers Process Batch Launcher"
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
    // +----------------------------------------------------------------------------------------------------------------+

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        CduLBuffersProcessBatch: Codeunit "PWD Buffers Process Batch";
        RecLRef: RecordRef;
    begin
        //***************************************************************************************************
        //                                        Buffers Processing                                        //
        //***************************************************************************************************
        Commit();
        Clear(CduLBuffersProcessBatch);
        Clear(RecLRef);
        RecLRef.Open(DATABASE::"PWD Receipt Line Buffer");
        CduLBuffersProcessBatch.FctInit(RecLRef);
        if CduLBuffersProcessBatch.Run() then;
        RecLRef.Close();

        Commit();
        Clear(CduLBuffersProcessBatch);
        Clear(RecLRef);
        RecLRef.Open(DATABASE::"PWD Customer Buffer");
        CduLBuffersProcessBatch.FctInit(RecLRef);
        if CduLBuffersProcessBatch.Run() then;
        RecLRef.Close();

        Commit();
        Clear(CduLBuffersProcessBatch);
        Clear(RecLRef);
        RecLRef.Open(DATABASE::"PWD Sales Header Buffer");
        CduLBuffersProcessBatch.FctInit(RecLRef);
        if CduLBuffersProcessBatch.Run() then;
        RecLRef.Close();

        Commit();
        Clear(CduLBuffersProcessBatch);
        Clear(RecLRef);
        RecLRef.Open(DATABASE::"PWD Item Jounal Line Buffer");
        CduLBuffersProcessBatch.FctInit(RecLRef);
        if CduLBuffersProcessBatch.Run() then;
        RecLRef.Close();

        Commit();
        Clear(CduLBuffersProcessBatch);
        Clear(RecLRef);
        RecLRef.Open(DATABASE::"PWD Sales Line Buffer");
        CduLBuffersProcessBatch.FctInit(RecLRef);
        if CduLBuffersProcessBatch.Run() then;
        RecLRef.Close();
    end;
}

