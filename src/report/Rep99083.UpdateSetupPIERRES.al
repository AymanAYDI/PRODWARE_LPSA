report 99083 "PWD Update Setup PIERRES"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));

            trigger OnAfterGetRecord()
            var
                LMachCenter: Record "Machine Center";
            begin
                if not LMachCenter.Get('MA00000') then begin
                    LMachCenter.Init;
                    LMachCenter.Validate("No.", 'MA00000');
                    LMachCenter.Validate("Work Center No.", 'C00000');
                    LMachCenter.Validate(Capacity, 1);
                    LMachCenter.Validate(Name, 'DEBUT OF Aciers');
                    LMachCenter.ResourceBehavior := LMachCenter.ResourceBehavior::FiniteCapacity;
                    LMachCenter.Validate(PlanningGroup, 'ACIERS');
                    if LMachCenter.Insert(true) then;
                end;

                if not LMachCenter.Get('MA99999') then begin
                    LMachCenter.Init;
                    LMachCenter.Validate("No.", 'MA99999');
                    LMachCenter.Validate(Capacity, 1);
                    LMachCenter.Validate("Work Center No.", 'C99999');
                    LMachCenter.Validate(Name, 'FIN OF Aciers');
                    LMachCenter.ResourceBehavior := LMachCenter.ResourceBehavior::FiniteCapacity;
                    LMachCenter.Validate(PlanningGroup, 'ACIERS');
                    if LMachCenter.Insert(true) then;
                end;

                if not LMachCenter.Get('MP00000') then begin
                    LMachCenter.Init;
                    LMachCenter.Validate("No.", 'MP00000');
                    LMachCenter.Validate(Capacity, 1);
                    LMachCenter.Validate("Work Center No.", 'C00000');
                    LMachCenter.Validate(Name, 'DEBUT OF Pierres');
                    LMachCenter.ResourceBehavior := LMachCenter.ResourceBehavior::InfiniteCapacity;
                    LMachCenter.Validate(PlanningGroup, 'PIERRES');
                    if LMachCenter.Insert(true) then;
                end;

                if not LMachCenter.Get('MP99999') then begin
                    LMachCenter.Init;
                    LMachCenter.Validate("No.", 'MP99999');
                    LMachCenter.Validate(Capacity, 1);
                    LMachCenter.Validate("Work Center No.", 'C99999');
                    LMachCenter.Validate(Name, 'FIN OF Pierres');
                    LMachCenter.ResourceBehavior := LMachCenter.ResourceBehavior::InfiniteCapacity;
                    LMachCenter.Validate(PlanningGroup, 'PIERRES');
                    if LMachCenter.Insert(true) then;
                end;
                if not LMachCenter.Get('MR00000') then begin
                    LMachCenter.Init;
                    LMachCenter.Validate("No.", 'MR00000');
                    LMachCenter.Validate(Capacity, 1);
                    LMachCenter.Validate("Work Center No.", 'C00000');
                    LMachCenter.Validate(Name, 'DEBUT OF Préparage');
                    LMachCenter.ResourceBehavior := LMachCenter.ResourceBehavior::InfiniteCapacity;
                    LMachCenter.Validate(PlanningGroup, 'PREPARAGES');
                    if LMachCenter.Insert(true) then;
                end;
                if not LMachCenter.Get('MR99999') then begin
                    LMachCenter.Init;
                    LMachCenter.Validate("No.", 'MR99999');
                    LMachCenter.Validate(Capacity, 1);
                    LMachCenter.Validate("Work Center No.", 'C99999');
                    ;
                    LMachCenter.Validate(Name, 'FIN OF Préparage');
                    LMachCenter.ResourceBehavior := LMachCenter.ResourceBehavior::InfiniteCapacity;
                    LMachCenter.Validate(PlanningGroup, 'PREPARAGES');
                    if LMachCenter.Insert(true) then;
                end;
                if not LMachCenter.Get('ML00000') then begin
                    LMachCenter.Init;
                    LMachCenter.Validate("No.", 'ML00000');
                    LMachCenter.Validate(Capacity, 1);
                    LMachCenter.Validate("Work Center No.", 'C00000');
                    LMachCenter.Validate(Name, 'DEBUT OF Levées Elipses');
                    LMachCenter.ResourceBehavior := LMachCenter.ResourceBehavior::InfiniteCapacity;
                    LMachCenter.Validate(PlanningGroup, 'LEVEES_ELI');
                    if LMachCenter.Insert(true) then;
                end;
                if not LMachCenter.Get('ML99999') then begin
                    LMachCenter.Init;
                    LMachCenter.Validate("No.", 'ML99999');
                    LMachCenter.Validate(Capacity, 1);
                    LMachCenter.Validate("Work Center No.", 'C99999');
                    LMachCenter.Validate(Name, 'FIN OF Levées Elipses');
                    LMachCenter.ResourceBehavior := LMachCenter.ResourceBehavior::InfiniteCapacity;
                    LMachCenter.Validate(PlanningGroup, 'LEVEES_ELI');
                    if LMachCenter.Insert(true) then;
                end;
            end;
        }
        dataitem(MC; "Machine Center")
        {

            trigger OnAfterGetRecord()
            begin
                case CopyStr(MC.Name, 1, 3) of
                    'PIE':
                        begin
                            MC.ResourceBehavior := MC.ResourceBehavior::FiniteCapacity;
                            MC.PlanningGroup := 'PIERRES';
                            Modify;
                        end;

                    'LEV':
                        begin
                            MC.ResourceBehavior := MC.ResourceBehavior::FiniteCapacity;
                            MC.PlanningGroup := 'LEVEES_ELI';
                            Modify;
                        end;

                    'PRE':
                        begin
                            MC.ResourceBehavior := MC.ResourceBehavior::FiniteCapacity;
                            MC.PlanningGroup := 'PREPARAGES';
                            Modify;
                        end;
                end;
            end;
        }
        dataitem("Work Center"; "Work Center")
        {
            DataItemTableView = WHERE ("No." = FILTER ('*P'));

            trigger OnAfterGetRecord()
            begin
                "Work Center".ResourceBehavior := "Work Center".ResourceBehavior::Ignored;
                "Work Center".PlanningGroup := '';
                "Work Center".Blocked := true;
                Modify;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        RecLItem: Record Item;
        RecLItem2: Record Item;
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        CreateProdOrderLines: Codeunit "Create Prod. Order Lines";
        WhseProdRelease: Codeunit "Whse.-Production Release";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        Window: Dialog;
        Direction: Option Forward,Backward;
        CalcLines: Boolean;
        CalcRoutings: Boolean;
        CalcComponents: Boolean;
        CreateInbRqst: Boolean;
        RecLRoutingH: Record "Routing Header";
}

