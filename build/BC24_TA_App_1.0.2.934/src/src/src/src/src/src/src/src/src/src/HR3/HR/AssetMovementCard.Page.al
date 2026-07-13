Page 50307 "Asset Movement Card"
{
    PageType = Card;
    SourceTable = "Asset Movement Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doc No. field.';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Asset No field.';
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Asset Description field.';
                }
                field(Requestor; Rec.Requestor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requestor field.';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requestor Name field.';
                }
                field("Date Needed"; Rec."Date Needed")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Date Needed field.';
                }
                field("Date Requested"; Rec."Date Requested")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Date Requested field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Global Dimension 2 Name"; Rec."Global Dimension 2 Name")
                {
                    Caption = 'Department Name';
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Date Moved"; Rec."Date Moved")
                {
                    Caption = 'Date Issued';
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Date Issued field.';
                }
                field("Date Returned"; Rec."Date Returned")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Date Returned field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Reason field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Outlook) { }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Assign)
            {
                ApplicationArea = basic;
                Image = Register;
                ToolTip = 'Executes the Assign action.';
                trigger OnAction()
                begin
                    Rec.TestField("Asset No.");
                    UsetSetup.Get(Database.UserId);
                    if UsetSetup."Can Issue Asset" = false then Error('You have no right to assign asset');
                    Rec.Status := Rec.Status::Issued;
                    Rec."Date Moved" := Today;
                    Rec.Modify();
                end;
            }
            action(Reject)
            {
                ApplicationArea = basic;
                Image = Reject;
                ToolTip = 'Executes the Reject action.';
                trigger OnAction()
                begin
                    if UsetSetup."Can Issue Asset" = false then Error('You have no right to reject request');
                    Rec.Status := Rec.Status::"Request Reject";
                    Rec.Modify();
                end;
            }
            action(Returned)
            {
                ApplicationArea = basic;
                Image = Return;
                ToolTip = 'Executes the Returned action.';
                trigger OnAction()
                begin
                    if UsetSetup."Can Issue Asset" = false then Error('You have no right to recieve asset');
                    Rec.Status := Rec.Status::Returned;
                    Rec."Date Returned" := Today;
                    Rec.Modify();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.Status = Rec.Status::Requested then begin
            Rec.Status := Rec.Status::"Request Recieved";
            Rec.Modify();
        end
    end;

    var
        UsetSetup: Record "User Setup";
}

