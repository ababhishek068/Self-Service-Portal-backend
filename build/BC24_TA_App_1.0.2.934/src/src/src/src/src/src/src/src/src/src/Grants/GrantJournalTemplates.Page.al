Page 50081 "Grant Journal Templates"
{
    Caption = 'Grant Journal Templates';
    PageType = Card;
    SourceTable = "Job-Journal Template";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(PostingNoSeries; Rec."Posting No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting No. Series field.';
                }
                field(Recurring; Rec.Recurring)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recurring field.';
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Code field.';

                    trigger OnValidate()
                    begin
                        SourceCodeOnAfterValidate;
                    end;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason Code field.';
                }
                field(FormID; Rec."Form ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Form ID field.';
                }
                field(FormName; Rec."Form Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Form Name field.';
                }
                field(TestReportID; Rec."Test Report ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Test Report ID field.';
                }
                field(TestReportName; Rec."Test Report Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Test Report Name field.';
                }
                field(PostingReportID; Rec."Posting Report ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Posting Report ID field.';
                }
                field(PostingReportName; Rec."Posting Report Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Posting Report Name field.';
                }
                field(ForcePostingReport; Rec."Force Posting Report")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Force Posting Report field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Template)
            {
                Caption = 'Te&mplate';
                action(Batches)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batches';
                    RunObject = Page "Job Journal Batches";
                    RunPageLink = "Journal Template Name" = field(Name);
                    ToolTip = 'Executes the Batches action.';
                }
            }
        }
    }

    local procedure SourceCodeOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}

