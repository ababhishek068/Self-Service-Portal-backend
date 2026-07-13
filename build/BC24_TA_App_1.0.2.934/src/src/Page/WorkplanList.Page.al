page 50211 "Workplan List"
{
    // version W/P

    CardPageID = "Workplan Card";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = Workplan;
    SourceTableView = WHERE("Closed" = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Workplan Code."; Rec."Workplan Code.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Workplan Code. field.';
                }

                field("Workplan Description"; Rec."Workplan Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Workplan Description field.';
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }

                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }


                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                }

                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {

                action(Print)
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTip = 'Executes the Print action.';

                    trigger OnAction();
                    begin

                        Rec.RESET;
                        Rec.SETFILTER("Workplan Code.", Rec."Workplan Code.");
                        // REPORT.RUN(REPORT::"WP Report", TRUE, TRUE, Rec);
                        Rec.RESET;
                    end;
                }


            }
        }
    }



}

