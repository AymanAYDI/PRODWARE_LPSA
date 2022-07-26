tableextension 60000 "PWD Location" extends Location
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE10.001:GR 01/07/2011   Connector integration
    //                              - Add field "WMS_Location"
    // 
    // //>>LAP2.05
    // FE_LAPIERRETTE_NDT01.001: LY 17/04/2013:  New Demand
    //                                           Add fields
    //                                             50000 "Req. Wksh. Template"
    //                                             50001 "Req. Wksh. Name"
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    fields
    {
        field(50000; "PWD Req. Wksh. Template"; Code[10])
        {
            Caption = 'Planning Wksh. Template';
            Description = 'LAP2.05';
            TableRelation = "Req. Wksh. Template" WHERE(Type = CONST(Planning));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //>>FE_LAPIERRETTE_NDT01.001
                IF "PWD Req. Wksh. Template" <> xRec."PWD Req. Wksh. Template" THEN
                    "PWD Req. Wksh. Name" := '';
                //<<FE_LAPIERRETTE_NDT01.001
            end;
        }
        field(50001; "PWD Req. Wksh. Name"; Code[10])
        {
            Caption = 'Planning Wksh. Name';
            Description = 'LAP2.05';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                RecLReqWkshName: Record "Requisition Wksh. Name";
            //    "-- LAP2.05 --": Integer;
            begin
                //>>FE_LAPIERRETTE_NDT01.001
                IF "PWD Req. Wksh. Template" <> '' THEN BEGIN
                    RecLReqWkshName.SETRANGE("Worksheet Template Name", "PWD Req. Wksh. Template");
                    IF PAGE.RUNMODAL(Page::"Req. Wksh. Names", RecLReqWkshName) = ACTION::LookupOK THEN
                        "PWD Req. Wksh. Name" := RecLReqWkshName.Name;
                END;
                //<<FE_LAPIERRETTE_NDT01.001
            end;
        }
        field(8073282; "PWD WMS_Location"; Boolean)
        {
            Caption = 'WMS_Location';
            Description = 'ProdConnect1.5';
            DataClassification = CustomerContent;
        }
    }
}

