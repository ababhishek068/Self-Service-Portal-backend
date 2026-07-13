Page 51021 "Registry Personel Files Card"
{
    PageType = Card;
    SourceTable = "Registry Files";
    SourceTableView = where("File Status" = filter(New));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(FileNo; Rec."File No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File No. field.';
                }


                field("Folio No"; Rec."Folio No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Folio No field.';
                }
                field("File Subject/Description"; Rec."File Subject/Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Subject/Description field.';
                }
                field(DateofIssue; Rec."Date of Issue")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Issue field.';
                }
                field(IssuingOfficer; Rec."Issuing Officer")
                {
                    Caption = 'Action Officer';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Action Officer field.';
                }
                field(CirculationReason; Rec."Circulation Reason")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Circulation Reason field.';
                }
                field(ExpectedReturnDate; Rec."Expected Return Date")
                {
                    Caption = 'Date Returned';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Returned field.';
                }
                field(ReceivingOfficer; Rec."Receiving Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Officer field.';
                }
                field(DeliveryOfficer; Rec."Delivery Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivery Officer field.';
                }

                field(IssuingOfficeName; Rec."Issuing Office Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issuing Office Name field.';
                }
                field(RecievingOfficerName; Rec."Recieving Officer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recieving Officer Name field.';
                }
                field(DeliveryOfficerName; Rec."Delivery Officer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivery Officer Name field.';
                }
                field(FolioNo; Rec."Folio No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Folio No field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134918),
                              "No." = FIELD("File No.");
            }
            systempart(Control18; Notes) { }
            systempart(Control19; MyNotes) { }
            systempart(Control20; Links) { }
        }
    }

    actions
    {
        area(creation)
        {
            action("Dispatch ")
            {
                ApplicationArea = Basic;
                Caption = 'Dispatch File';
                ToolTip = 'Executes the Dispatch File action.';

                trigger OnAction()
                begin
                    if (Confirm('Dispatch File?', true) = false) then Error('Cancelled!');
                    Rec."Dispatch Status" := Rec."dispatch status"::Dispatched;
                    Rec.Modify;
                    Message('File Dispatched!')
                end;
            }
            action(Archive)
            {
                ApplicationArea = Basic;
                Caption = 'Archive File';
                ToolTip = 'Executes the Archive File action.';

                trigger OnAction()
                begin
                    if Confirm('Archive File?', false) = false then exit;

                    Rec."File Status" := Rec."file status"::Archived;
                    Rec.Modify;
                    Message('File archived!');
                end;
            }

            action("Print/Preview")
            {
                Caption = 'Print/Preview';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                ApplicationArea = ALL;
                PromotedIsBig = true;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction();
                begin
                    Rec.RESET;
                    Rec.SETFILTER("File No.", rec."File No.");
                    report.run(report::"File Movement Report", true, false, rec);
                end;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."File Status" := Rec."File Status"::New;

    end;
}

