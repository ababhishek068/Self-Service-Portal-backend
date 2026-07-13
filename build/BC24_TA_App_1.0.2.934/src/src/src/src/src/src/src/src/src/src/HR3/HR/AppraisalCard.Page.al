page 51272 "Appraisal Card"
{
    PageType = Card;
    SourceTable = "HR Appraisal Card1";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appraisal Code field.';
                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Staff No field.';
                }
                field("Appraisal Type"; Rec."Appraisal Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appraisal Type field.';
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appraisal Period field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field("Resp Center"; Rec."Resp Center")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Resp Center field.';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
            }
            part("Appraisal Score Card"; "Appraisal Part List")
            {
                ApplicationArea = basic;
                Caption = 'Appraisal Score Card';
                SubPageLink = "Document No" = FIELD("Appraisal Code"),
                              "Appraisal Period" = FIELD("Appraisal Period"),
                              Section = CONST("Strategic Objectives");
            }
            part("Quarter Two Performance Review"; "Appraisal Part List")
            {
                ApplicationArea = basic;
                Caption = 'Quarter Two Performance Review';
                SubPageLink = "Document No" = FIELD("Appraisal Code"),
                              "Appraisal Period" = FIELD("Appraisal Period"),
                              Section = CONST(Quarter2);
            }
            part("Mid year Performance Review"; "Appraisal Part List")
            {
                ApplicationArea = basic;
                Caption = 'Mid year Performance Review';
                SubPageLink = "Document No" = FIELD("Appraisal Code"),
                              "Appraisal Period" = FIELD("Appraisal Period"),
                              Section = CONST("Mid Year");
            }
            part("End Year Performance Review"; "Appraisal Part List")
            {
                ApplicationArea = basic;
                Caption = 'End Year Performance Review';
                SubPageLink = "Document No" = FIELD("Appraisal Code"),
                              "Appraisal Period" = FIELD("Appraisal Period"),
                              Section = CONST("End Year");
            }
            part("Core Competencies and Values"; "Appraisal Part List")
            {
                ApplicationArea = basic;
                Caption = 'Core Competencies and Values';
                SubPageLink = "Document No" = FIELD("Appraisal Code"),
                              "Appraisal Period" = FIELD("Appraisal Period"),
                              Section = CONST("Core Values");
            }
            part("Performance Improvement Plan"; "Appraisal Part List")
            {
                ApplicationArea = basic;
                Caption = 'Performance Improvement Plan';
                SubPageLink = "Document No" = FIELD("Appraisal Code"),
                              "Appraisal Period" = FIELD("Appraisal Period"),
                              Section = CONST("Performance Improvement Plan");
            }
            part("Learning and Development"; "Appraisal Part List")
            {
                ApplicationArea = basic;
                Caption = 'Learning and Development';
                SubPageLink = "Document No" = FIELD("Appraisal Code"),
                              "Appraisal Period" = FIELD("Appraisal Period"),
                              Section = CONST("Learning and Development");
            }
            part("Notes and Validation"; "Appraisal Part List")
            {
                ApplicationArea = basic;
                Caption = 'Notes and Validation';
                SubPageLink = "Document No" = FIELD("Appraisal Code"),
                              "Appraisal Period" = FIELD("Appraisal Period"),
                              Section = CONST("Notes and Validation");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Employee")
            {
                Caption = '&Employee';
                action("print report")
                {
                    ApplicationArea = basic;
                    Caption = 'print report';
                    Image = Relatives;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Report "HR Employee PIF";
                    ToolTip = 'Executes the print report action.';
                }
            }
        }
    }
}

