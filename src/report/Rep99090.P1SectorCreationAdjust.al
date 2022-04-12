report 99090 "P1 : Sector Creation+Adjust"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = WHERE (Number = CONST (1));

            trigger OnAfterGetRecord()
            begin
                //Planification Sector Creation
                //ACIERS
                T8076506.Init;
                T8076506.Validate(Type, T8076506.Type::PS);
                T8076506.Validate(Name, 'ACIERS');
                T8076506.Validate(Description, 'Secteur Acier');
                if T8076506.Insert(true) then;

                //AUTRES (PIERRES)
                T8076506.Init;
                T8076506.Validate(Type, T8076506.Type::PS);
                T8076506.Validate(Name, 'PIERRES');
                T8076506.Validate(Description, 'Secteurs Pierres');
                if T8076506.Insert(true) then;

                //AUTRES (PIERRES)
                T8076506.Init;
                T8076506.Validate(Type, T8076506.Type::PS);
                T8076506.Validate(Name, 'LEVEES_ELI');
                T8076506.Validate(Description, 'Secteurs Levées Elipses');
                if T8076506.Insert(true) then;

                //AUTRES (PIERRES)
                T8076506.Init;
                T8076506.Validate(Type, T8076506.Type::PS);
                T8076506.Validate(Name, 'PREPARAGES');
                T8076506.Validate(Description, 'Secteurs Préparages');
                if T8076506.Insert(true) then;


                //Planification Groupes de planification
                //ACIERS
                T8076505.Init;
                T8076505.Validate(Type, T8076505.Type::PS);
                T8076505.Validate(Code, 'ACIERS');
                T8076505.Validate(Description, 'Groupe Aciers');
                T8076505.Validate(Container, 'ACIERS');
                if T8076505.Insert(true) then;

                //LEVEES
                T8076505.Init;
                T8076505.Validate(Type, T8076505.Type::PS);
                T8076505.Validate(Code, 'LEVEES_ELI');
                T8076505.Validate(Description, 'Groupe Levees Elipses');
                T8076505.Validate(Container, 'LEVEES_ELI');
                if T8076505.Insert(true) then;

                //PREPARAGE
                T8076505.Init;
                T8076505.Validate(Type, T8076505.Type::PS);
                T8076505.Validate(Code, 'PREPARAGES');
                T8076505.Validate(Description, 'Groupe Preparages');
                T8076505.Validate(Container, 'PREPARAGES');
                if T8076505.Insert(true) then;


                //AUTRES
                T8076505.Init;
                T8076505.Validate(Type, T8076505.Type::PS);
                T8076505.Validate(Code, 'PIERRES');
                T8076505.Validate(Description, 'Groupe Pierres');
                T8076505.Validate(Container, 'PIERRES');
                if T8076505.Insert(true) then;
            end;
        }
        dataitem(WC; "Work Center")
        {
            DataItemTableView = WHERE ("No." = FILTER (<> '*P'));

            trigger OnAfterGetRecord()
            begin
                Validate(ResourceBehavior, ResourceBehavior::Ignored);
                Modify(true);
            end;

            trigger OnPreDataItem()
            begin
                //Mise à jour des Comportement ressources P1 (erreurs sur PIERRES)
            end;
        }
        dataitem(WC2; "Work Center")
        {
            DataItemTableView = WHERE (ResourceBehavior = FILTER (<> Ignored));

            trigger OnAfterGetRecord()
            begin
                case CopyStr(WC2.Name, 1, 3) of
                    'PIE':
                        WC2.Validate(PlanningGroup, 'PIERRES');
                    'ACI':
                        WC2.Validate(PlanningGroup, 'ACIERS');
                    'PRE':
                        WC2.Validate(PlanningGroup, 'PREPARAGES');
                end;
                Modify(true);
            end;

            trigger OnPreDataItem()
            begin
                //Update Group Planning
            end;
        }
        dataitem(MC; "Machine Center")
        {

            trigger OnAfterGetRecord()
            begin
                Validate(ResourceBehavior, ResourceBehavior::Ignored);
                Modify(true);
            end;

            trigger OnPreDataItem()
            begin
                //Setup Ressource Behavior
            end;
        }
        dataitem(RH; "Routing Header")
        {
            DataItemTableView = WHERE (Description = CONST ('TEST'));

            trigger OnAfterGetRecord()
            begin
                Delete;
            end;
        }
        dataitem(RH2; "Routing Header")
        {

            trigger OnAfterGetRecord()
            var
                RecLItem: Record Item;
                RecLItem2: Record Item;
            begin
                if CopyStr(RH2.Description, 1, 7) = 'Ru8sp30' then begin
                    RH2.Validate(PlanningGroup, 'PIERRES');
                    Modify(true)
                end else begin
                    case CopyStr(RH2."No.", 1, 3) of
                        'PIE':
                            begin
                                RH2.Validate(PlanningGroup, 'PIERRES');
                                Modify(true);
                            end;
                        'ACI':
                            begin
                                RH2.Validate(PlanningGroup, 'ACIERS');
                                Modify(true);
                            end;
                        'PRE':
                            begin
                                RH2.Validate(PlanningGroup, 'PREPARAGES');
                                Modify(true);
                            end;
                        else begin
                                RecLItem.Reset;
                                RecLItem.SetRange(RecLItem."Routing No.", RH2."No.");
                                if RecLItem.FindFirst then
                                    case RecLItem."Item Category Code" of
                                        'ACI':
                                            begin
                                                RH2.Validate(PlanningGroup, 'ACIERS');
                                                Modify(true);
                                            end;
                                        'PIE':
                                            begin
                                                RH2.Validate(PlanningGroup, 'PIERRES');
                                                Modify(true);
                                            end;
                                        'PRE':
                                            begin
                                                RH2.Validate(PlanningGroup, 'PREPARAGES');
                                                Modify(true);
                                            end;
                                        'P. BROCHE':
                                            begin
                                                RH2.Validate(PlanningGroup, 'PIERRES');
                                                Modify(true);
                                            end;
                                        'TOURN':
                                            begin
                                                RH2.Validate(PlanningGroup, 'PIERRES');
                                                Modify(true);
                                            end;
                                    end
                                else begin
                                    RecLItem2.Reset;
                                    RecLItem2.SetRange("No.", CopyStr(RH2."No.", 1, 8));
                                    if RecLItem2.FindFirst then
                                        case RecLItem2."Item Category Code" of
                                            'ACI':
                                                begin
                                                    RH2.Validate(PlanningGroup, 'ACIERS');
                                                    Modify(true);
                                                end;
                                            'PIE':
                                                begin
                                                    RH2.Validate(PlanningGroup, 'PIERRES');
                                                    Modify(true);
                                                end;
                                            'PRE':
                                                begin
                                                    RH2.Validate(PlanningGroup, 'PREPARAGES');
                                                    Modify(true);
                                                end;
                                            'P. BROCHE':
                                                begin
                                                    RH2.Validate(PlanningGroup, 'PIERRES');
                                                    Modify(true);
                                                end;
                                            'TOURN':
                                                begin
                                                    RH2.Validate(PlanningGroup, 'PIERRES');
                                                    Modify(true);
                                                end;
                                        end;
                                end;
                            end;
                    end;
                end
            end;
        }
        dataitem(POL; "Prod. Order Line")
        {
            DataItemTableView = WHERE (Status = FILTER (<> Finished));

            trigger OnAfterGetRecord()
            var
                RecLRouting: Record "Routing Header";
                RecLItem: Record Item;
            begin
                if RecLItem.Get(POL."Item No.") then begin
                    if RecLRouting.Get(RecLItem."Routing No.") then begin
                        POL.PlanningGroup := RecLRouting.PlanningGroup;
                        POL.Modify;
                    end;
                end;
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
        T8076506: Record PlannerOnePlanGroupContainer;
        T8076505: Record PlannerOnePlanningGroup;
}

