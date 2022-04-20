pageextension 50081 pageextension50081 extends "Resource Capacity Settings"
{
    actions
    {

        //Unsupported feature: Code Modification on "Action 50.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF WeekTotal <= 0 THEN
          ERROR(Text001);

        #4..39
            IF ResCapacityEntry2.FIND('+') THEN;
            LastEntry := ResCapacityEntry2."Entry No." + 1;
            ResCapacityEntry2.RESET;
            ResCapacityEntry2."Entry No." := LastEntry;
            ResCapacityEntry2.Capacity := -1 * (TempCapacity - SelectCapacity());
            ResCapacityEntry2."Resource No." := "No.";
        #46..57
        ELSE
          MESSAGE(Text008);
        CurrPage.CLOSE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..42
            // PLAW12.0 Issue with Time column not set to default value before insert
            ResCapacityEntry2.INIT;
            // PLAW12.0 End
        #43..60
        */
        //end;
    }
}

