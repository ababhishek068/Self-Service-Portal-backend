page 50034 "Courses Master"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Courses Master";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Stage field.';

                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = All;
                    caption = 'Credit Hours';
                    ToolTip = 'Specifies the value of the Credit Hours field.';

                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Type field.';

                }
                field("Unit Category"; Rec."Unit Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Category field.';

                }
                field("Teaching Type"; Rec."Teaching Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Teaching Type field.';

                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code field.';

                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Name field.';

                }
                field("School Code"; Rec."School Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the School Code field.';

                }
                field("School Name"; Rec."School Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the School Name field.';

                }
                field("Old Unit"; Rec."Old Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Old Unit field.';

                }
                field("Disable Inc Rule"; Rec."Disable Inc Rule")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disable Inc Rule field.';

                }
                field("Time Table"; Rec."Time Table")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Time Table field.';

                }
                field("Charge Credits"; Rec."Charge Credits")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Credits field.';

                }
                field("Prerequisite Unit"; Rec."Prerequisite Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Prerequisite Unit field.';

                }
                field(" Core Prerequisite Unit"; Rec." Core Prerequisite Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the  Core Prerequisite Unit field.';

                }
                field("Substitute Unit"; Rec."Substitute Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Substitute Unit field.';

                }

            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action("Class Session")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = Segment;
                RunObject = page "Class Setup";
                RunPageLink = "Unit Code" = field(Code);
                ToolTip = 'Executes the Class Session action.';
            }
            /*
            action("UnitPreq")
            {
                ApplicationArea = All;
                Promoted = true;
                Caption = 'Unit Prerequisites';
                Image = Segment;
                RunObject = page "Unit Prerequisite";
                RunPageLink = Unit = field(Code);
            }
            
            action("UnitEquiv")
            {
                ApplicationArea = All;
                Promoted = true;
                Caption = 'Unit Equivalent';
                Image = Segment;
                RunObject = page "Unit Equivalent";
                RunPageLink = Unit = field(Code);
            }
            */
            action("UpdateCredits")
            {
                ApplicationArea = All;
                Promoted = true;
                Caption = 'Update Student Credits';
                Image = Segment;
                ToolTip = 'Executes the Update Student Credits action.';
                trigger OnAction()
                var
                    StudUnits: record "Student Units";
                begin
                    StudUnits.reset;
                    StudUnits.setrange(Unit, Rec.Code);
                    if StudUnits.find('-') then begin
                        repeat
                            StudUnits."No. Of Units" := Rec.Units;
                            StudUnits.modify;
                        until StudUnits.next = 0;
                    end
                    //Message('Completed');
                end;
            }
        }
    }
}