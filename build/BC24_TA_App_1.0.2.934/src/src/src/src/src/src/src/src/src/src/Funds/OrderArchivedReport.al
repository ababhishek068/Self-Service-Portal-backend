// Report 70135671 "LPO Archived"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Layouts/LPOReport.rdlc';

//     dataset
//     {
//         dataitem("Purchase Header Archive"; "Purchase Header Archive")
//         {
//             RequestFilterFields = "No.";
//             column(ReportForNavId_1; 1)
//             {
//             }


//             column(Approver1; Approver1)
//             {

//             }

//             column(Approver2; Approver2)
//             {

//             }

//             column(Pay_to_Address; "Pay-to Address")
//             {

//             }
//             column(BuyfromVendorNo_PurchaseHeader; "Purchase Header Archive"."Buy-from Vendor No.")
//             {
//             }
//             column(CompanyinforPicture; Companyinfor.Picture)
//             {
//             }
//             column(CompanyinforName; Companyinfor.Name)
//             {
//             }
//             column(CompanyinforAddress; Companyinfor.Address)
//             {
//             }
//             //column(QuoteNo_PurchaseHeader; "Purchase Header Archive"."Quote No.")
//             //{
//             //}
//             column(CompanyinforAddress2; Companyinfor."Address 2")
//             {
//             }
//             column(CompanyinfoCity; Companyinfor.City)
//             {
//             }
//             column(CompanyinforPhoneNo; Companyinfor."Phone No.")
//             {
//             }
//             column(CompanyinforEMail; Companyinfor."E-Mail")
//             {
//             }
//             column(CompanyinforHomePage; Companyinfor."Home Page")
//             {
//             }
//             column(BuyfromVendorName_PurchaseHeader; "Purchase Header Archive"."Buy-from Vendor Name")
//             {
//             }
//             column(VendorOrderNo; "Purchase Header Archive"."Vendor Order No.")
//             {
//             }
//             column(PaytoAddress2; "Purchase Header Archive"."Pay-to Address 2")
//             { 
//             }
//             column(PaytoCity; "Purchase Header Archive"."Pay-to City")
//             {
//             }
//             column(ShortcutDimension1Code_PurchaseHeader; "Purchase Header Archive"."Shortcut Dimension 1 Code")
//             {
//             }
//             //column(Requiredon_PurchaseHeader; "Purchase Header Archive"."Expiry Date")
//             //{
//             //}
//             // column(RFQNo_PurchaseHeader; "Purchase Header Archive"."RFQ No.")
//             // {
//             // }
//             column(No_PurchaseHeader; "Purchase Header Archive"."No.")
//             {
//             }
//             column(Number; Number)
//             {
//             }
//             column(Due_Date; "Due Date")
//             {

//             }
//             //column(Tendor_Number; "Tendor Number") { }

//             column(Vendor_Invoice_No_; "Vendor Invoice No.") { }
//             column(NumberText; NumberText[1])
//             {
//             }
//             column(OrderDate_PurchaseHeader; "Purchase Header Archive"."Order Date")
//             {
//             }
//             column(Amt; Amt)
//             {
//             }
//             column(Picture; Companyinfor.Picture)
//             {
//             }
//             column(Currency_Code; "Currency Code")
//             {

//             }
//             column(Posting_Description; "Posting Description")
//             {

//             }
//             //column(Request_Description; "Request Description")
//             {

//             }
//             dataitem("Purchase Line Archive Archive"; "Purchase Line Archive")
//             {
//                 DataItemLink = "Document No." = field("No.");
//                 column(ReportForNavId_2; 2)
//                 {
//                 }
//                 column(Lineamount_PurchaseLine; "Purchase Line Archive"."Line Amount")
//                 {
//                 }
//                 column(UnitPriceLCY_PurchaseLine; "Purchase Line Archive"."Unit Price (LCY)")
//                 {
//                 }
//                 column(Quantity_PurchaseLine; "Purchase Line Archive".Quantity)
//                 {
//                 }
//                 column(Description_PurchaseLine; "Purchase Line Archive".Description)
//                 {
//                 }
//                 column(Description2_PurchaseLine; "Purchase Line Archive"."Description 2")
//                 {
//                 }
//                 column(No_PurchaseLine; "Purchase Line Archive"."No.")
//                 {
//                 }
//                 column(DirectUnitCost_PurchaseLine; "Purchase Line Archive"."Direct Unit Cost")
//                 {
//                 }
//                 column(LocationCode_PurchaseLine; "Purchase Line Archive"."Location Code")
//                 {
//                 }


//                 column(ApproverID_ApprovalEntry; "ApprovalEntry"."Approver ID")
//                 {
//                 }
//                 column(LastDateTimeModified_ApprovalEntry; "ApprovalEntry"."Last Date-Time Modified")
//                 {
//                 }


//                 column(Signature_UserSetup; UserRec1."User Signature")
//                 {
//                 }
//                 column(ApprovalDesignation_UserSetup; UserRec1."Approval Title")
//                 {
//                 }
//                 column(Signature_UserSetup2; UserRec2."User Signature")
//                 {
//                 }
//                 column(ApprovalDesignation_UserSetup2; UserRec2."Approval Title")
//                 {
//                 }
//                 column(Signature_UserSetup3; UserRec3."User Signature")
//                 {
//                 }
//                 column(ApprovalDesignation_UserSetup3; UserRec3."Approval Title")
//                 {
//                 }
//                 column(Signature_UserSetup4; UserRec4."User Signature")
//                 {
//                 }
//                 column(ApprovalDesignation_UserSetup4; UserRec4."Approval Title")
//                 {
//                 }
//                 column(Signature_UserSetup5; UserRec5."User Signature")
//                 {
//                 }
//                 column(ApprovalDesignation_UserSetup5; UserRec5."Approval Title")
//                 {
//                 }

//             }

//             dataitem(DataItem1102755002; "Approval Entry")
//             {
//                 DataItemLink = "Document No." = FIELD("No.");
//                 DataItemTableView = WHERE(Status = CONST(Approved));
//                 column(Sequence_No_; "Sequence No.")
//                 {
//                 }
//                 column(Sender_ID; "Sender ID")
//                 {
//                 }
//                 column(Approver_ID; "Approver ID")
//                 {
//                 }

//                 column(Date_Time_Sent_for_Approval; "Date-Time Sent for Approval")
//                 {
//                 }

//                 column(Last_Date_Time_Modified; "Last Date-Time Modified")
//                 {
//                 }


//                 // column(SenderName; SenderName)
//                 // {

//                 // }
//             }



//             trigger OnAfterGetRecord()
//             begin
//                 CalcFields(Amount);
//                 Amt := 0;
//                 //sum amounts in line
//                 "Purchase Line Archive".Reset;
//                 "Purchase Line Archive".SetRange("Purchase Line Archive"."Document No.", "Purchase Header"."No.");
//                 if "Purchase Line Archive".Find('-') then begin
//                     repeat
//                         Amt := Amt + "Purchase Line Archive"."Line Amount";
//                     until "Purchase Line Archive".Next = 0;
//                 end;
//                 
//                 CheckReport.FormatNoText(NumberText, (Amt), '');

//                 ApprovalEntry.reset;
//                 ApprovalEntry.setrange("Document No.", "Purchase Header"."No.");
//                 ApprovalEntry.setrange(Status, ApprovalEntry.Status::Approved);
//                 if ApprovalEntry.find('-') then begin
//                     repeat
//                         if ApprovalEntry."Sequence No." = 1 then begin
//                             UserRec1.reset;
//                             UserRec1.setrange("User ID", ApprovalEntry."Approver ID");
//                             if UserRec1.find('-') then begin
//                                 UserRec1.calcfields("User Signature");
//                             end;
//                         end;
//                         if ApprovalEntry."Sequence No." = 2 then begin
//                             UserRec2.reset;
//                             UserRec2.setrange("User ID", ApprovalEntry."Approver ID");
//                             if UserRec2.find('-') then begin
//                                 UserRec2.calcfields("User Signature");
//                             end;
//                         end;
//                         if ApprovalEntry."Sequence No." = 3 then begin
//                             UserRec3.reset;
//                             UserRec3.setrange("User ID", ApprovalEntry."Approver ID");
//                             if UserRec3.find('-') then begin
//                                 UserRec3.calcfields("User Signature");
//                             end;
//                         end;
//                         if ApprovalEntry."Sequence No." = 4 then begin
//                             UserRec4.reset;
//                             UserRec4.setrange("User ID", ApprovalEntry."Approver ID");
//                             if UserRec4.find('-') then begin
//                                 UserRec4.calcfields("User Signature");
//                             end;
//                         end;
//                         if ApprovalEntry."Sequence No." = 5 then begin
//                             UserRec5.reset;
//                             UserRec5.setrange("User ID", ApprovalEntry."Approver ID");
//                             if UserRec5.find('-') then begin
//                                 UserRec5.calcfields("User Signature");
//                             end;
//                         end;
//                     until ApprovalEntry.next = 0;
//                 end;

//             end;

//             trigger OnPreDataItem()
//             begin
//                 LastFieldNo := FieldNo("No.");




//                 //Approvers

//                 Approver1 := '';
//                 Approver2 := '';
//                 Approver3 := '';
//                 Date1 := 0D;
//                 Date2 := 0D;
//                 Date3 := 0D;

//                 ApprovalEntry.Reset;
//                 ApprovalEntry.SetRange(ApprovalEntry."Document No.", GetFilter("Purchase Header"."No."));
//                 ApprovalEntry.SetRange(ApprovalEntry.Status, ApprovalEntry.Status::Approved);
//                 if ApprovalEntry.Find('-') then begin
//                     repeat
//                         if ApprovalEntry."Sequence No." = 1 then begin
//                             Approver1 := ApprovalEntry."Sender ID";

//                             //Approver1 := DelStr(Approver1, 1, 16);
//                             HREmp.Reset();
//                             HREmp.SetRange("User ID", Approver1);
//                             if HREmp.FindFirst() then begin
//                                 Approver1 := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
//                             end;

//                             Approver2 := ApprovalEntry."Approver ID";

//                             HREmp.Reset();
//                             HREmp.SetRange("User ID", Approver2);
//                             if HREmp.FindFirst() then begin
//                                 Approver2 := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
//                             end;

//                             //Approver2 := DelStr(Approver2, 1, 16);
//                         end;

//                         if ApprovalEntry."Sequence No." = 2 then begin
//                             Approver3 := ApprovalEntry."Approver ID";
//                             //Approver3 := DelStr(Approver3, 1, 16);
//                             HREmp.Reset();
//                             HREmp.SetRange("User ID", Approver2);
//                             if HREmp.FindFirst() then begin
//                                 Approver3 := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
//                             end;
//                         end;
//                     until ApprovalEntry.Next = 0;
//                 end;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPreReport()
//     begin
//         Companyinfor.Get;
//         Companyinfor.CalcFields(Companyinfor.Picture);
//     end;

//     var
//         Companyinfor: Record "Company Information";
//         Number: Integer;
//         NumberText: array[2] of Text[80];
//        CheckReport: Report  "Check Translation Management"
//         LastFieldNo: Integer;
//         Approver1: Text;
//         Approver2: Text;
//         Approver3: Text;
//         Date1: Date;
//         Date2: Date;
//         Date3: Date;
//         ApprovalEntry: Record "Approval Entry";
//         Amt: Decimal;
//         UserRec1: Record "User Setup";
//         UserRec2: Record "User Setup";
//         UserRec3: Record "User Setup";
//         UserRec4: Record "User Setup";
//         UserRec5: Record "User Setup";

//         HREmp: Record "HR-Employee";
//     }
// }

