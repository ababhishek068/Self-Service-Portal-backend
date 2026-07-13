page 50545 "User Setup Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "User Setup";

    layout
    {
        area(Content)
        {
            group(User)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';

                }
                field(UserName; Rec.UserName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UserName field.';
                }
                field("Approval Title"; Rec."Approval Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Title field.';
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
                field("Staff Travel Account"; Rec."Staff Travel Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff Travel Account field.';
                }
                field("Cash Advance Staff Account"; Rec."Cash Advance Staff Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cash Advance Staff Account field.';
                }
                field("Other Advance Staff Account"; Rec."Other Advance Staff Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Advance Staff Account field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("Approval Administrator"; Rec."Approval Administrator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who has rights to unblock approval workflows, for example, by delegating approval requests to new substitute approvers and deleting overdue approval requests.';
                }
                field("Petty Cash Account No"; Rec."Petty Cash Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Petty Cash Account No field.';
                }
                field("Multiple Banks"; Rec."Multiple Banks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Multiple Banks field.';
                }
                field(Leave; Rec.Leave)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leave field.';
                }
            }
            group(Allowed)
            {
                field("Advance Amt Approval Limit"; Rec."Advance Amt Approval Limit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Advance Amt Approval Limit field.';
                }
                field("Allow FA Posting From"; Rec."Allow FA Posting From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow FA Posting From field.';
                }
                field("Allow FA Posting To"; Rec."Allow FA Posting To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow FA Posting To field.';
                }
                field("Allow Posting From"; Rec."Allow Posting From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the earliest date on which the user is allowed to post to the company.';
                }
                field("Allow Posting To"; Rec."Allow Posting To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date on which the user is allowed to post to the company.';
                }
                field("Allow Transaction Reversal"; Rec."Allow Transaction Reversal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Allow Transaction Reversal field.';
                }
                field("Can Allow Exam Attendance"; Rec."Can Allow Exam Attendance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Allow Exam Attendance field.';
                }
                field("Reverse Hostel Allocations"; Rec."Reverse Hostel Allocations")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reverse Hostel Allocations field.';
                }
                field("Can Assign Lecturer Unit"; Rec."Can Assign Lecturer Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Assign Lecturer Unit field.';
                }

                field("Can Reopen Order"; Rec."Can Reopen Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Reopen Order field.';
                }
                field("Can Create Vendor"; Rec."Can Create Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Create Vendor field.';
                }
                field("Can Edit Budget"; Rec."Can Edit Budget")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Edit Budget field.';
                }
                field("Can Edit Marks"; Rec."Can Edit Marks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Edit Marks field.';
                }

                field("Can Post Journal"; Rec."Can Post Journal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Post Journal field.';
                }

                field("Post Batch Receipts"; Rec."Post Batch Receipts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Batch Receipts field.';
                }
                field("Can Print Transcript"; Rec."Can Print Transcript")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Print Transcript field.';
                }
                field("Can Stop Reg."; Rec."Can Stop Reg.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Stop Reg. field.';
                }

                field("Cash Account No"; Rec."Cash Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cash Account No field.';
                }
                field("Can Create Student"; Rec."Can Create Student")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Create Student field.';
                }
                field("View Payroll"; Rec."View Payroll")
                {
                    Caption = 'Can View Payroll';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can View Payroll field.';
                }
                field("Can Change Profile"; Rec."Can Change Profile")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Change Profile field.';
                }
                field("Can Manage Workflow"; Rec."Can Manage Workflow")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Manage Workflow field.';
                }
                field("Can Issue Asset"; Rec."Can Issue Asset")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Can Issue Asset field.';
                }
                field("Can Release Open PO"; Rec."Can Release Open PO")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Can Release Open PO field.';
                }

                field("User Signature"; Rec."User Signature")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the signature that has been set up for the user';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
                }
            }



        }
        area(factboxes)
        {
            part(Control149; "User Signature")
            {
                Caption = 'Documents Signature';
                ApplicationArea = Basic, Suite;
                SubPageLink = "User ID" = FIELD("User ID");
                // Visible = NOT IsOfficeAddin;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}