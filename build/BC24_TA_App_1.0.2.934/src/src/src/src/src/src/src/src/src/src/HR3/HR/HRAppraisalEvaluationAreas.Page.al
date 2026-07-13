Page 51175 "HR Appraisal Evaluation Areas"
{
    PageType = List;
    SourceTable = "HR Appraisal Evaluation Areas";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = true;
                field(CategorizeAs; Rec."Categorize As")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Categorize As field.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(SubCategory; Rec."Sub Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sub Category field.';
                }
                field(Group; Rec.Group)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Group field.';
                }
                field(AssignTo; Rec."Assign To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assign To field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(IncludeinEvaluationForm; Rec."Include in Evaluation Form")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Include in Evaluation Form field.';
                }
            }
        }
    }

    actions { }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

