Page 51080 "Individual Workplan Objective"
{
    PageType = List;
    SourceTable = "Individual Work Plan Objective";
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

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ObjTarget)
            {
                ApplicationArea = Basic;
                Caption = 'Targets';
                Image = AllLines;
                Promoted = true;
                RunObject = Page "Ind Workplan Target Form";
                RunPageLink = Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period"), "Objective Entry No" = field("Entry No");
                ToolTip = 'Executes the Targets action.';
            }
            
        }
        
    }
  var
  Departmentobj: Record "HR Appraisal Dept. Obj. Setup";

}

