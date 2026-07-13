Page 51035 "Studnt ID Replacement Pen"
{
    CardPageID = "Stunt Rep ID Card";
    Editable = false;
    PageType = List;
    SourceTable = "Corporate Management";
    SourceTableView = where("Permission Granted" = filter(false),
                            Type = filter(Student));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Requestdate; Rec."Request date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request date field.';
                }
                field(RequiredDate; Rec."Required Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field(StudentNo; Rec."Requisitioning Officer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Student No.';
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(Name; Rec."Visitor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(PhoneNumber; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(InitiatedBy; Rec."Initiated By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Initiated By field.';
                }
                field(ClearedBy; Rec."Cleared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared By field.';
                }
                field(IssueDate; Rec."Issue Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issue Date field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(admin)
            {
                ApplicationArea = Basic;
                Caption = 'Admit';
                Image = AddContacts;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Admit action.';

                trigger OnAction()
                begin
                    Rec.TestField("Visitor Name");
                    Rec.TestField("ID Number");
                    Rec.TestField("Phone Number");
                    Rec.TestField("Person To See");
                    Rec.TestField("Purpose of Visit");
                    Rec.TestField(Department);
                    Rec.TestField("Visitor Pass No.");

                    if Confirm('Mark visitor as admitted?', true) = false then Error('Cancelled by user: ' + UserId);

                    Rec."Initiated By" := UserId;
                    Rec."Initiated By Time" := Time;
                    Rec."Initiated Date" := Today;
                    Rec.Status := Rec.Status::Entered;
                    Rec.Modify;
                    Message('Admitted!');
                end;
            }
            separator(Action14) { }
            action("Recommend Student ID Replacement")
            {
                ApplicationArea = Basic;
                Caption = 'Recommend Student ID Replacement';
                Image = Allocate;
                ToolTip = 'Executes the Recommend Student ID Replacement action.';

                trigger OnAction()
                begin
                    if Rec."Room Availability" <> true then
                        if Confirm('Recommend Student ID Replacement?', true) then
                            Rec."Meeting Held?" := true;
                    Rec."Recommend Stnt ID Replacement" := true;
                    Rec."Room Availability" := true;
                    Rec.Date := Today;
                    Rec."Issue Date" := Today;
                    Rec."Cleared By" := UserId;
                    Rec."Cleared Date" := Today;
                end;
            }
            separator(Action9) { }
            action("Grant Permission")
            {
                ApplicationArea = Basic;
                Caption = 'Grant Permission';
                Image = approve;
                ToolTip = 'Executes the Grant Permission action.';

                trigger OnAction()
                begin
                    if Rec."Permission Granted" <> true then
                        if Confirm('Proceed and Grant Permision For Student ID Replacement?', true) then
                            Rec."Meeting Held?" := true;
                    Rec."Room Availability" := true;
                    Rec.Date := Today;
                    Rec."Issue Date" := Today;
                    Rec."Cleared By" := UserId;
                    Rec."Cleared Date" := Today;
                    Rec."Permission Granted" := true;
                    Rec.SDate := Today;
                    Rec.LDate := Today;
                    Message('Permision Granted!');
                end;
            }
        }
    }
}

