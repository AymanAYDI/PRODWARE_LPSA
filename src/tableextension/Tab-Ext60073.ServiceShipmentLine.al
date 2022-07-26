tableextension 60073 "PWD ServiceShipmentLine" extends "Service Shipment Line"
{
    fields
    {
        field(50000; "PWD Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "PWD Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
            DataClassification = CustomerContent;
        }
    }
}
