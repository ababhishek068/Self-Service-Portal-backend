Report 50180 "Purchase Requisition Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PurchaseRequisitionForm.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1) { }
            column(PRN_No; "Purchase Header"."No.") { }
            column(Status; Status) { }
            column(Approver1; Approver1) { }

            column(Approver2; Approver2) { }
            column(Department; "Purchase Header"."Shortcut Dimension 2 Code") { }
            column(CompanyInformationPicture; CompanyInformation.Picture) { }
            column(PostingDate_PurchaseHeader; "Purchase Header"."Posting Date") { }
            column(CompanyInformationAddress; CompanyInformation.Address) { }
            column(RequestorName_PurchaseHeader; "Purchase Header"."Requestor Name") { }
            column(ApprovedDate_PurchaseHeader; "Purchase Header"."Posting Date") { }
            column(CompanyInformationAddress2; CompanyInformation."Address 2") { }
            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationPhoneNo; CompanyInformation."Phone No.") { }
            column(CompanyInformationEMail; CompanyInformation."E-Mail") { }
            column(CompanyInformationHomePage; CompanyInformation."Home Page") { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ReportForNavId_5; 5) { }
                column(ItemNo; "Purchase Line"."No.") { }
                column(No_PurchaseLine; "Purchase Line"."No.") { }
                column(Description; "Purchase Line".Description) { }
                column(Description2; "Purchase Line"."Description 2") { }
                column(UnitofMeasure; "Purchase Line"."Unit of Measure") { }
                column(Description2_PurchaseLine; "Purchase Line"."Description 2") { }
                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure") { }
                column(Quantity; "Purchase Line".Quantity) { }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity) { }
                column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost") { }
                column(Lineamount_PurchaseLine; "Purchase Line"."Line Amount") { }
                column(AmountIncludingVAT_PurchaseLine; "Purchase Line"."Amount Including VAT") { }
                column(EstimatedUnitCost; "Purchase Line"."Unit Cost") { }
                column(Amount; "Purchase Line".Amount) { }
                column(ActualCost; "Purchase Line"."Direct Unit Cost") { }
                column(RequestSummary_PurchaseLine; "Purchase Line"."Request Summary") { }
                column(TenderQuotationRef; "Purchase Line"."No.") { }
                column(Location_Code; "Location Code") { }
                column(ApproverID_ApprovalEntry; "ApprovalEntry"."Approver ID") { }
                column(LastDateTimeModified_ApprovalEntry; "ApprovalEntry"."Last Date-Time Modified") { }


                column(Signature_UserSetup; UserRec1."User Signature") { }
                column(ApprovalDesignation_UserSetup; UserRec1."Approval Title") { }
                column(Signature_UserSetup2; UserRec2."User Signature") { }
                column(ApprovalDesignation_UserSetup2; UserRec2."Approval Title") { }
                column(Signature_UserSetup3; UserRec3."User Signature") { }
                column(ApprovalDesignation_UserSetup3; UserRec3."Approval Title") { }
                column(Signature_UserSetup4; UserRec4."User Signature") { }
                column(ApprovalDesignation_UserSetup4; UserRec4."Approval Title") { }
                column(Signature_UserSetup5; UserRec5."User Signature") { }
                column(ApprovalDesignation_UserSetup5; UserRec5."Approval Title") { }

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("No.");




                    //Approvers

                    Approver1 := '';
                    Approver2 := '';
                    Approver3 := '';
                    Date1 := 0D;
                    Date2 := 0D;
                    Date3 := 0D;

                    ApprovalEntry.Reset;
                    ApprovalEntry.SetRange(ApprovalEntry."Document No.", GetFilter("Purchase Line"."No."));
                    ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
                    if ApprovalEntry.Find('-') then begin
                        repeat
                            if ApprovalEntry."Sequence No." = 1 then begin
                                Approver1 := ApprovalEntry."Sender ID";
                                //Remove AGRICULTUREAUTH\
                                Approver1 := DelStr(Approver1, 1, 16);

                                Approver2 := ApprovalEntry."Approver ID";
                                //Remove AGRICULTUREAUTH\
                                Approver2 := DelStr(Approver2, 1, 16);
                            end;

                            if ApprovalEntry."Sequence No." = 2 then begin
                                Approver3 := ApprovalEntry."Approver ID";
                                //Remove AGRICULTUREAUTH\
                                Approver3 := DelStr(Approver3, 1, 16);
                            end;
                        until ApprovalEntry.Next = 0;
                    end;
                end;
            }
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Entry No.") where(Status = const(Approved));
                column(ReportForNavId_1102755002; 1102755002) { }
                column(SequenceNo_ApprovalEntry; "Approval Entry"."Sequence No.") { }
                column(SenderID_ApprovalEntry; "Approval Entry"."Sender ID") { }
                column(ApproverID_ApprovalEntr; "Approval Entry"."Approver ID") { }
                column(DateTimeSentforApproval_ApprovalEntry; "Approval Entry"."Date-Time Sent for Approval") { }
                column(LastDateTimeModified_ApprovalEntr; "Approval Entry"."Last Date-Time Modified") { }
                column(ApprovalEntryDateApproved; ApprovalEntry."Last Date-Time Modified") { }
                column(ApprovalEntryTimeApproved; ApprovalEntry."Last Date-Time Modified") { }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");




                //Approvers

                Approver1 := '';
                Approver2 := '';
                Approver3 := '';
                Date1 := 0D;
                Date2 := 0D;
                Date3 := 0D;

                ApprovalEntry.Reset;
                ApprovalEntry.SetRange(ApprovalEntry."Document No.", GetFilter("Purchase Header"."No."));
                ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            Approver1 := ApprovalEntry."Sender ID";
                            //Remove AGRICULTUREAUTH\
                            Approver1 := DelStr(Approver1, 1, 16);

                            Approver2 := ApprovalEntry."Approver ID";
                            //Remove AGRICULTUREAUTH\
                            Approver2 := DelStr(Approver2, 1, 16);
                        end;

                        if ApprovalEntry."Sequence No." = 2 then begin
                            Approver3 := ApprovalEntry."Approver ID";
                            //Remove AGRICULTUREAUTH\
                            Approver3 := DelStr(Approver3, 1, 16);
                        end;
                    until ApprovalEntry.Next = 0;
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                ApprovalEntry.reset;
                ApprovalEntry.setrange("Document No.", "Purchase Header"."No.");
                ApprovalEntry.setrange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            UserRec1.reset;
                            UserRec1.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec1.find('-') then begin
                                UserRec1.calcfields("User Signature");
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 2 then begin
                            UserRec2.reset;
                            UserRec2.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec2.find('-') then begin
                                UserRec2.calcfields("User Signature");
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 3 then begin
                            UserRec3.reset;
                            UserRec3.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec3.find('-') then begin
                                UserRec3.calcfields("User Signature");
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 4 then begin
                            UserRec4.reset;
                            UserRec4.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec4.find('-') then begin
                                UserRec4.calcfields("User Signature");
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 5 then begin
                            UserRec5.reset;
                            UserRec5.setrange("User ID", ApprovalEntry."Approver ID");
                            if UserRec5.find('-') then begin
                                UserRec5.calcfields("User Signature");
                            end;
                        end;
                    until ApprovalEntry.next = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(CompanyInformation.Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        LastFieldNo: Integer;
        Approver1: Text;
        Approver2: Text;
        Approver3: Text;
        Date1: Date;
        Date2: Date;
        Date3: Date;
        ApprovalEntry: Record "Approval Entry";
        UserRec1: Record "User Setup";
        UserRec2: Record "User Setup";
        UserRec3: Record "User Setup";
        UserRec4: Record "User Setup";
        UserRec5: Record "User Setup";
}

