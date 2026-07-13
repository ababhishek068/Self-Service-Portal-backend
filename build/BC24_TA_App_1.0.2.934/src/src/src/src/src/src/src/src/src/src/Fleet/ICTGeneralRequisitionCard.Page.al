page 50572 "ICT General Requisition Card"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ICT General Requisition Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Requisition Category"; Rec."Requisition Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requisition Category field.';

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    caption = 'Station';
                    ToolTip = 'Specifies the value of the Station field.';

                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    caption = 'Department';
                    ToolTip = 'Specifies the value of the Department field.';

                }
                field("Urgency Priority"; Rec."Urgency Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Urgency Priority field.';

                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Required Date field.';

                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Requestor Name field.';
                }
                field("Resolution Status"; Rec."Resolution Status")
                {
                    ApplicationArea = All;
                    editable = false;
                    ToolTip = 'Specifies the value of the Resolution Status field.';

                }
                field(Assignee; Rec.Assignee)
                {
                    ApplicationArea = All;
                    editable = false;
                    ToolTip = 'Specifies the value of the Assignee field.';

                }
                field("General Description"; Rec."General Description")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the General Description field.';
                }
                field("Resolution Remarks"; Rec."Resolution Remarks")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Resolution Remarks field.';
                }
            }
            // part(Lines; "ICT Requisition Lines")
            // {
            //     ApplicationArea = basic;
            //     SubPageLink = No = field(No);

            // }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Caption = 'Attachments';
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Requisition")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Print Requisition action.';

                trigger OnAction()
                var
                    ICTReq: Record "ICT General Requisition Header";
                begin
                    ICTReq.reset;
                    ICTReq.Setfilter(ICTReq.No, Rec.No);
                    if ICTReq.find('-') then
                        report.run(50609, true, true, ICTReq);
                end;
            }
            action("Submit Request")
            {
                ApplicationArea = Basic;
                Caption = 'Submit Request';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Submit Request action.';

                trigger OnAction()
                var
                begin
                    if Confirm('Do you want to Submit this requisition?', false) = true then begin
                        Rec."Resolution Status" := Rec."Resolution Status"::InProgress;
                        Rec.modify();
                    end;
                end;
            }
            action(Close)
            {
                ApplicationArea = Basic;
                Caption = 'Close';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Close action.';

                trigger OnAction()
                var
                begin
                    if Confirm('Do you want to close this requisition?', false) = true then begin
                        Rec."Resolution Status" := Rec."Resolution Status"::Closed;
                        Rec.modify();
                    end;
                end;
            }
        }
    }
}