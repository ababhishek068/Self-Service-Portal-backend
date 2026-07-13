Page 51009 "Legal Approved (Approved)"
{
    CardPageID = "Legal Card";
    Editable = false;
    PageType = List;
    SourceTable = "Legal Management";
    SourceTableView = where(Status = filter(Approved),
                            "Send to Litigation" = const(false));
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
                field(LitigationStatus; Rec."Litigation Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Litigation Status field.';
                }
                field(Name; Rec."Visitor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
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
                field(Description; Rec."Purpose of Visit")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(FunctionName; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(DepartmentName; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Department Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field(ConcernedDepartmentNotified; Rec."Concerned Department Notified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Concerned Department Notified field.';
                }
                field(DocumentsAttached; Rec."Documents Attached?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Documents Attached? field.';
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
            action(clear)
            {
                ApplicationArea = Basic;
                Caption = 'Clear';
                Image = AddContacts;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Clear action.';

                trigger OnAction()
                begin
                    //TESTFIELD("Name");
                    Rec.TestField("Meeting Held?");
                    Rec.TestField("Meeting Schedule Date");
                    //TESTFIELD("Person To See");
                    Rec.TestField(Comments);
                    Rec.TestField(Department);


                    if Confirm('Clear Legal Issue?', true) = false then Error('Cancelled by user: ' + UserId);

                    Rec."Cleared By" := UserId;
                    Rec."Cleared By Time" := Time;
                    Rec."Cleared Date" := Today;
                    Rec.Status := Rec.Status::Posted;
                    Rec.Modify;
                    Message('Cleared!');
                end;
            }
        }
    }
}

