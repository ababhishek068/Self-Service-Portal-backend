Page 51083 "Individual Workplan Target"
{
    PageType = List;
    SourceTable = "Individual Work Plan Target";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objective field.';
                }
                field("Objective Target"; Rec."Objective Target")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objective Target field.';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ObjActivities)
            {
                ApplicationArea = Basic;
                Caption = 'Activities';
                Image = Employee;
                Promoted = true;
                RunObject = Page "Individual Workplan Activities";
                RunPageLink = Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period"), "Objective Entry No" = field("Entry No"), "Target Entry No" = field("Entry No");
                ToolTip = 'Executes the Activities action.';
            }
        }
    }
}

