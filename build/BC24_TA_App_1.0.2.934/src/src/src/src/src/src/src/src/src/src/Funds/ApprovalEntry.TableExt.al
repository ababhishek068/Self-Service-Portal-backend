tableextension 50023 "Approval Entry" extends "Approval Entry"
{

    fields
    {

        field(51000; "Approved By"; code[20]) { }
        field(51002; "Description"; text[200]) { }
        field(51003; "Updated"; Boolean) { }
        field(51004; "Document No2"; code[20]) { }
        field(50013; "Approval Comment"; Boolean)
        {
            CalcFormula = Exist("Approval Comment Line" WHERE("Table ID" = FIELD("Table ID"),
                                                               "Record ID to Approve" = FIELD("Record ID to Approve")));
            Caption = 'Approval Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Sender Name"; Text[100]) { }
        field(50015; "Approval Name"; Text[100]) { }

        modify(Status)
        {
            trigger OnBeforeValidate()
            var
                ApprovalCommPage: Page "Approval Comment Line";
                ApprovalCom: Record "Approval Comment Line";
                AppEntry: Record "Approval Entry";

            begin
                //Group Approval
                AppEntry.reset;
                AppEntry.setrange("Document No.", "Document No.");
                AppEntry.setrange("Table ID", "Table ID");
                AppEntry.Setrange("Sequence No.", "Sequence No.");
                AppEntry.Setrange(Status, Status::Open);
                if AppEntry.find('-') then begin
                    repeat
                        AppEntry.Status := Status;
                        AppEntry."Last Modified By User ID" := UserId;
                    // AppEntry.modify;
                    until AppEntry.next = 0;
                end;

                if Status = Status::Rejected then begin
                    CalcFields("Approval Comment");
                    if not GuiAllowed then exit;
                    if "Approval Comment" = false then begin
                        message('Please enter the document rejection comments');

                        ApprovalCom.reset;
                        ApprovalCom.setrange("Entry No.", "Entry No." + "Sequence No.");
                        if ApprovalCom.Find('-') then ApprovalCom.delete;

                        ApprovalCom.init;
                        ApprovalCom."Document No." := "Document No.";
                        ApprovalCom."Table ID" := "Table ID";
                        ApprovalCom."Sequence No" := "Sequence No.";
                        ApprovalCom."Entry No." := "Entry No." + "Sequence No.";
                        ApprovalCom."User ID" := UserId;
                        ApprovalCom."Record ID to Approve" := "Record ID to Approve";
                        //  ApprovalCom.RecordId := "RecordId";
                        ApprovalCom.insert;

                        ApprovalCom.reset;
                        ApprovalCom.setrange("Entry No.", "Entry No." + "Sequence No.");
                        if ApprovalCom.Find('-') then begin
                            ApprovalCommPage.SetRecord(ApprovalCom);
                            ApprovalCommPage.Run();
                        end;

                    end;

                end;
            end;
        }
    }
    procedure ShowDocument()
    begin
        case "Table ID" of
            DATABASE::"Purchase Header": //TODO: Seperate rfq and purchase quotes from here with procurement module
                begin
                    if not purchaseHeader.get("Document Type", "Document No.") then
                        exit;
                    case "Document Type" of
                        "Document Type"::Quote:
                            Page.Run(Page::"Internal Requisitions U", purchaseHeader);
                    end;
                end;
        end;
    end;

    var
        purchaseHeader: Record "Purchase Header";
}