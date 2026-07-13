report 50015 "Direct Voucher Report"
{
    ApplicationArea = All;
    Caption = 'Direct Voucher Report';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(PaymentHeaderGreenCom; "Payment Header GreenCom")
        {
            column(PVNo; "PV No") { }
            column(Picture; Companyinfor.Picture) { }
            column(CompanyinforPicture; Companyinfor.Picture) { }
            column(CompanyinforName; Companyinfor.Name) { }
            column(CompanyinforAddress; Companyinfor.Address) { }
            column(CompanyinforAddress2; Companyinfor."Address 2") { }
            column(CompanyinfoCity; Companyinfor.City) { }
            column(CompanyinforPhoneNo; Companyinfor."Phone No.") { }
            column(CompanyinforEMail; Companyinfor."E-Mail") { }
            column(CompanyinforHomePage; Companyinfor."Home Page") { }
            column(ChequeNo; "Cheque No") { }
            column(DocumentDate; "Document Date") { }
            column(DocumentType; "Document Type") { }
            column(ModifiedDate; "Modified Date") { }
            column(NoSeries; "No. Series") { }
            column(PayingBank; "Paying Bank") { }
            column(PayingBankName; "Paying Bank Name") { }
            column(PaymentMode; "Payment Mode") { }
            column(PostingDescription; "Posting Description") { }
            column(RaisedBy; "Raised By") { }
            column(Status; Status) { }
            column(VendorName; "Vendor Name") { }
            column(VendorNo; "Vendor No.") { }
            column(Approver1; Approver1) { }
            column(Approver2; Approver2) { }
            column(Approver3; Approver3) { }
            column(Approver4; Approver4) { }
            column(Approver5; Approver5) { }
            column(Date1; Date1) { }
            column(Date2; Date2) { }
            column(Date3; Date3) { }
            column(Date4; Date4) { }
            column(Date5; Date5) { }
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
            dataitem("Direct Voucher Lines"; "Direct Voucher Lines")
            {
                column(Document_No; "Document No") { }
                column(Line_No; "Line No") { }
                column(Invoice_No; "Invoice No") { }
                column(Vendor_No; "Vendor No") { }
                column(Invoice_Amount; "Invoice Amount") { }
                column(Paid_Amount; "Paid Amount") { }
                column(Posted_; "Posted ") { }


            }
            trigger OnAfterGetRecord()
            begin


                ApprovalEntry.reset;
                ApprovalEntry.setrange("Document No.", PaymentHeaderGreenCom."PV No");
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

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("PV No");

                Companyinfor.Get;
                Companyinfor.CalcFields(Companyinfor.Picture);


                //Approvers

                Approver1 := '';
                Approver2 := '';
                Approver3 := '';
                Approver4 := '';
                Approver5 := '';
                // Date1 := 0D;
                // Date2 := 0D;
                // Date3 := 0D;
                // Date4 := 0D;
                // Date5 := 0D;

                ApprovalEntry.Reset;
                ApprovalEntry.SetRange(ApprovalEntry."Document No.", GetFilter(PaymentHeaderGreenCom."PV No"));
                ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.Find('-') then begin
                    repeat
                        if ApprovalEntry."Sequence No." = 1 then begin
                            Approver1 := ApprovalEntry."Sender ID";
                            Date1 := ApprovalEntry."Last Date-Time Modified";

                            //Approver1 := DelStr(Approver1, 1, 16);
                            HREmp.Reset();
                            HREmp.SetRange("User ID", Approver1);
                            if HREmp.FindFirst() then begin
                                Approver1 := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 2 then begin
                            Approver2 := ApprovalEntry."Approver ID";
                            Date2 := ApprovalEntry."Last Date-Time Modified";

                            HREmp.Reset();
                            HREmp.SetRange("User ID", Approver2);
                            if HREmp.FindFirst() then begin
                                Approver2 := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                            end;

                            //Approver2 := DelStr(Approver2, 1, 16);
                        end;

                        if ApprovalEntry."Sequence No." = 3 then begin
                            Approver3 := ApprovalEntry."Approver ID";
                            Date3 := ApprovalEntry."Last Date-Time Modified";
                            //Approver3 := DelStr(Approver3, 1, 16);
                            HREmp.Reset();
                            HREmp.SetRange("User ID", Approver3);
                            if HREmp.FindFirst() then begin
                                Approver3 := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 4 then begin
                            Approver4 := ApprovalEntry."Approver ID";
                            Date4 := ApprovalEntry."Last Date-Time Modified";
                            //Approver3 := DelStr(Approver3, 1, 16);
                            HREmp.Reset();
                            HREmp.SetRange("User ID", Approver4);
                            if HREmp.FindFirst() then begin
                                Approver4 := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                            end;
                        end;
                        if ApprovalEntry."Sequence No." = 5 then begin
                            Approver5 := ApprovalEntry."Approver ID";
                            Date5 := ApprovalEntry."Last Date-Time Modified";
                            //Approver3 := DelStr(Approver3, 1, 16);
                            HREmp.Reset();
                            HREmp.SetRange("User ID", Approver5);
                            if HREmp.FindFirst() then begin
                                Approver5 := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                            end;
                        end;
                    until ApprovalEntry.Next = 0;
                end;
            end;



        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
    var
        Companyinfor: Record "Company Information";
        LastFieldNo: Integer;
        Approver1: Text;
        Approver2: Text;
        Approver3: Text;
        Approver4: Text;
        Approver5: Text;
        Date1: DateTime;
        Date2: DateTime;
        Date3: DateTime;
        Date4: DateTime;
        Date5: DateTime;
        ApprovalEntry: Record "Approval Entry";
        UserRec1: Record "User Setup";
        UserRec2: Record "User Setup";
        UserRec3: Record "User Setup";
        UserRec4: Record "User Setup";
        UserRec5: Record "User Setup";

        HREmp: Record "HR-Employee";
}
