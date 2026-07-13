page 51068 "Receipts List FC"
{
    CardPageID = "Receipt Header FC";
    Editable = false;
    UsageCategory = lists;
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Receipts Header";
    SourceTableView = WHERE("Posted Count" = filter(0),
                            Status = FILTER(<> Cancelled));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")

                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field("Sales Person"; Rec."Sales Person")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sales Person field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field(Control1102755007; Rec.Posted)
                {
                    ShowCaption = false;
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field("Amount Recieved"; Rec."Amount Recieved")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount Recieved field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field("Print No."; Rec."Print No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Print No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Printed field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Created Date Time field.';
                }
                field("Register No."; Rec."Register No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Register No. field.';
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the From Entry No. field.';
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the To Entry No. field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Patient Appointment No"; Rec."Patient Appointment No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Patient Appointment No field.';
                }
                field("Surrender No"; Rec."Surrender No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Surrender No field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Posted Receipt Card")
            {
                RunObject = Page "Posted Receipt UP";
                RunPageLink = "No." = FIELD("No.");
                Visible = false;
                ToolTip = 'Executes the Posted Receipt Card action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter(Cashier, UserId);
    end;
}

