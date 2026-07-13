Report 50192 "Purchase Requisition Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/PurchRequisitionReport.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(PRN_No; "Purchase Header"."No.") { }
            column(Department; "Purchase Header"."Shortcut Dimension 2 Code") { }
            column(Project; Project) { }
            column(RequestorName_PurchaseHeader; "Requestor Name") { }
            column(CompanyInformationPicture; CompanyInformation.Picture) { }
            column(CompanyInformationAddress; CompanyInformation.Address) { }
            column(CompanyInformationAddress2; CompanyInformation."Address 2") { }
            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationpost; CompanyInformation."Post Code") { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationPhoneNo; CompanyInformation."Phone No.") { }
            column(CompanyInformationEMail; CompanyInformation."E-Mail") { }
            column(PostingDate; "Purchase Header"."Posting Date") { }
            column(DocumentDate_PurchaseHeader; "Document Date") { }
            column(Status; "Purchase Header".Status) { }
            column(CompanyInformationHomePage; CompanyInformation."Home Page") { }
            column(Approver1; Approver2) { }
            column(Approver2; Approver2) { }
            column(Approver3; Approver3) { }
            column(ApproverSign1; UserRec1."User Signature") { }
            column(ApproverSign2; UserREc2."User Signature") { }
            column(ApproverSign3; UserRec3."User Signature") { }
            column(Date1; Date2) { }
            column(Date2; Date2) { }
            column(Date3; Date3) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(PurchaseLineType; "Purchase Line".Type) { }
                column(PurchaseLineNo; "Purchase Line"."No.") { }
                column(Description; "Purchase Line".Description) { }
                column(Description2; "Purchase Line"."Description 2") { }
                column(UnitofMeasure; "Purchase Line"."Unit of Measure") { }
                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure") { }
                column(Quantity; "Purchase Line".Quantity) { }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity) { }
                column(EstimatedUnitCost; "Purchase Line"."Direct Unit Cost") { }
                column(Amount; "Purchase Line"."Line Amount") { }
                column(ActualCost; "Purchase Line"."Direct Unit Cost") { }
                column(RequestSummary_PurchaseLine; "Request Summary") { }
                column(TenderQuotationRef; "Purchase Line"."No.") { }
                column(Request_Summary; "Request Summary") { }
                column(sno; sno) { }

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("No.");
                    //Approvers

                    Approver1 := '';
                    Approver2 := '';
                    Approver3 := '';
                    //sno:=0;
                    Date1 := 0D;
                    Date2 := 0D;
                    Date3 := 0D;

                    ApprovalEntry.Reset;
                    ApprovalEntry.SetRange(ApprovalEntry."Document No.", GetFilter("Purchase Line"."No."));
                    ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
                    if ApprovalEntry.Find('-') then begin
                        repeat
                            if ApprovalEntry."Sequence No." = 1 then begin
                                Approver1 := ApprovalEntry."Approver ID";
                                Date1 := DT2Date(ApprovalEntry."Date-Time Sent for Approval");
                                UserREc1.Reset();
                                UserREc1.SetRange("User ID", ApprovalEntry."Approver ID");
                                if UserREc1.Find('-') then
                                    UserREc1.CalcFields("User Signature");
                            end;
                            if ApprovalEntry."Sequence No." = 2 then begin
                                Approver2 := ApprovalEntry."Approver ID";
                                Date2 := DT2Date(ApprovalEntry."Date-Time Sent for Approval");
                                UserREc2.Reset();
                                UserREc2.SetRange("User ID", ApprovalEntry."Approver ID");
                                if UserREc2.Find('-') then
                                    UserREc2.CalcFields("User Signature");
                            end;

                            if ApprovalEntry."Sequence No." = 3 then begin
                                Approver3 := ApprovalEntry."Approver ID";
                                Date3 := DT2Date(ApprovalEntry."Date-Time Sent for Approval");
                                UserREc3.Reset();
                                UserREc3.SetRange("User ID", ApprovalEntry."Approver ID");
                                if UserREc3.Find('-') then
                                    UserREc3.CalcFields("User Signature");
                            end;
                        until ApprovalEntry.Next = 0;
                    end;
                end;

                trigger OnAfterGetRecord()
                var
                begin
                    sno := sno + 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                DimensionValue: Record "Dimension Value";
            begin
                Project := '';
                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Purchase Header"."Shortcut Dimension 2 Code");
                if DimensionValue.Find('-') then
                    Project := DimensionValue.Name;

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
        sno := 0;
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
        Project: Text[50];
        sno: Integer;
        ApprovalEntry: Record "Approval Entry";
        UserREc1: Record "User Setup";
        UserREc2: Record "User Setup";
        UserREc3: Record "User Setup";
}

