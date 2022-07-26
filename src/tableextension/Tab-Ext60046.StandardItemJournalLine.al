tableextension 60046 "PWD StandardItemJournalLine" extends "Standard Item Journal Line"
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
