Page 50836 "HR Qualifications"
{
    Caption = 'HR Qualifications ';
    DelayedInsert = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Qualifications';
    SourceTable = "HR Qualifications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(QualificationType; Rec."Qualification Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(AcademicLevel; Rec."Academic Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Academic Level field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Qualification)
            {
                Caption = 'Qualification';
                action(QualificationOverview)
                {
                    ApplicationArea = Basic;
                    Caption = 'Q&ualification Overview';
                    Image = QualificationOverview;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Qualification Overview";
                    ToolTip = 'Executes the Q&ualification Overview action.';
                }
            }
        }
    }
}

