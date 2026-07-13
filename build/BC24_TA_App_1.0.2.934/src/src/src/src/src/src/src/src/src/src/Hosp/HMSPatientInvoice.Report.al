Report 50258 "HMS Patient Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSPatientInvoice.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Patient Charges"; "HMS Patient Charges")
        {
            DataItemTableView = sorting("Patient No.", "Transaction Type", Date) order(ascending) where(Amount = filter(<> 0), Closed = const(false), "Receipt Reversed" = const(false));
            RequestFilterFields = "Patient No.", "Visit No", "Invoice Number";
            column(ReportForNavId_1; 1) { }
            column(PatientNo_HMSPatientCharges; "HMS Patient Charges"."Patient No.") { }
            column(ShortcutDimension1Code_HMSPatientCharges; "HMS Patient Charges"."Shortcut Dimension 1 Code") { }
            column(TransactionType_HMSPatientCharges; TranType) { }
            column(Code_HMSPatientCharges; "HMS Patient Charges".Code) { }
            column(Description_HMSPatientCharges; "HMS Patient Charges".Description) { }
            column(TranDate; "HMS Patient Charges".Date) { }
            column(Amount_HMSPatientCharges; "HMS Patient Charges".Amount) { }
            column(Remarks_HMSPatientCharges; "HMS Patient Charges".Remarks) { }
            column(Qty; Qty) { }
            column(AmountPaid_HMSPatientCharges; "HMS Patient Charges"."Amount Paid") { }
            column(ShortcutDimension2Code_HMSPatientCharges; "HMS Patient Charges"."Shortcut Dimension 2 Code") { }
            column(AppliedAmount_HMSPatientCharges; "HMS Patient Charges"."Applied Amount") { }
            column(Applyto_HMSPatientCharges; "HMS Patient Charges"."Apply to") { }
            column(Recognized_HMSPatientCharges; "HMS Patient Charges".Recognized) { }
            column(Posted_HMSPatientCharges; "HMS Patient Charges".Posted) { }
            column(PharmacyNo_HMSPatientCharges; "HMS Patient Charges"."Pharmacy No") { }
            column(Location_HMSPatientCharges; "HMS Patient Charges".Location) { }
            column(Unit_HMSPatientCharges; "HMS Patient Charges"."Doctors Amount") { }
            column(RecoveredFirst_HMSPatientCharges; "HMS Patient Charges"."Recovered First") { }
            column(Transfer_HMSPatientCharges; "HMS Patient Charges".Transfer) { }
            column(TransferAmount_HMSPatientCharges; "HMS Patient Charges"."Transfer Amount") { }
            column(Transfered_HMSPatientCharges; "HMS Patient Charges".Transfered) { }
            column(TransactonID_HMSPatientCharges; PatientCharges."Link No") { }
            column(NoSeries_HMSPatientCharges; "HMS Patient Charges"."No. Series") { }
            column(FullyPaid_HMSPatientCharges; "HMS Patient Charges"."Fully Paid") { }
            column(RoomAllocation_HMSPatientCharges; "HMS Patient Charges"."Room Allocation") { }
            column(Charge_HMSPatientCharges; "HMS Patient Charges".Charge) { }
            column(Reversed_HMSPatientCharges; "HMS Patient Charges".Reversed) { }
            column(Distribution_HMSPatientCharges; "HMS Patient Charges".Distribution) { }
            column(Quantity_HMSPatientCharges; decQuantity) { }
            column(Course_HMSPatientCharges; "HMS Patient Charges"."Invoice Number") { }
            column(AppliedPayment_HMSPatientCharges; "HMS Patient Charges"."Applied Payment") { }
            column(RecoveryPriority_HMSPatientCharges; "HMS Patient Charges"."Recovery Priority") { }
            column(FullTuitionFee_HMSPatientCharges; "HMS Patient Charges"."Full Tuition Fee") { }
            column(DistributionAccount_HMSPatientCharges; "HMS Patient Charges"."Distribution Account") { }
            column(Currency_HMSPatientCharges; "HMS Patient Charges".Currency) { }
            column(OverCharged_HMSPatientCharges; "HMS Patient Charges"."Over Charged") { }
            column(OverChargedAmount_HMSPatientCharges; "HMS Patient Charges"."Over Charged Amount") { }
            column(SystemCreated_HMSPatientCharges; "HMS Patient Charges"."System Created") { }
            column(ChargeGender_HMSPatientCharges; "HMS Patient Charges"."Charge Gender") { }
            column(CustomerNo_HMSPatientCharges; "HMS Patient Charges"."Customer No.") { }
            column(BillSection_HMSPatientCharges; "HMS Patient Charges"."Bill Section") { }
            column(LineNo_HMSPatientCharges; "HMS Patient Charges"."Line No") { }
            column(GLAccount_HMSPatientCharges; "HMS Patient Charges"."G/L Account") { }
            column(TreatmentNo_HMSPatientCharges; "HMS Patient Charges"."Treatment No.") { }
            column(InvoiceCounter_HMSPatientCharges; "HMS Patient Charges"."Invoice Counter") { }
            column(ApplicableSection_HMSPatientCharges; "HMS Patient Charges"."Applicable Section") { }
            column(LinkNo_HMSPatientCharges; "HMS Patient Charges"."Link No") { }
            column(LinkNoLk_HMSPatientCharges; "HMS Patient Charges"."Link No Lk") { }
            column(AppointmentNo_HMSPatientCharges; "HMS Patient Charges"."Appointment No.") { }
            column(PatientTypeLk_HMSPatientCharges; "HMS Patient Charges"."Patient Type Lk") { }
            column(AppointmentNoLk_HMSPatientCharges; "HMS Patient Charges"."Appointment No Lk") { }
            column(BillingType_HMSPatientCharges; "HMS Patient Charges"."Billing Type") { }
            column(BillingStartDate_HMSPatientCharges; "HMS Patient Charges"."Billing Start Date") { }
            column(BillingEndDate_HMSPatientCharges; "HMS Patient Charges"."Billing End Date") { }
            column(AdmissionNo_HMSPatientCharges; "HMS Patient Charges"."Admission No") { }
            column(DoctorID_HMSPatientCharges; "HMS Patient Charges"."Doctor ID") { }
            column(DimensionSetID_HMSPatientCharges; "HMS Patient Charges"."Dimension Set ID") { }
            column(NewDimensionSetID_HMSPatientCharges; "HMS Patient Charges"."New Dimension Set ID") { }
            column(GLAccountNo_HMSPatientCharges; "HMS Patient Charges"."G/L Account No") { }
            column(DoctorsAmount_HMSPatientCharges; "HMS Patient Charges"."Doctors Amount") { }
            column(InsuranceAmount_HMSPatientCharges; "HMS Patient Charges"."Insurance Amount") { }
            column(RunBal; RunBal) { }
            column(InsNo; HMSPatRec."Insurance No.") { }
            column(InsName; HMSPatRec."Insurance Name") { }
            column(MemberNo; HMSPatRec."Membership No") { }
            column(AdmDate; AdmissionDates) { }
            column(dischargeDate; DischargeDates) { }
            column(Ward; Ward_) { }
            column(Bed; Beds_) { }
            column(InvoiceNo; "HMS Patient Charges"."Posted Invoice No.") { }
            column(PatName; HMSPatRec.Surname + ' ' + HMSPatRec."Last Name") { }
            column(Balance; HMSPatRec."Bill Balance") { }
            column(InvAmt; InvAmt) { }
            column(RecAmt; Receipts) { }
            column(LogoName; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            column(CompInfAddress; CompInf.Address) { }
            column(CompInfAddress2; CompInf."Address 2") { }
            column(CompInfPhone; CompInf."Phone No.") { }
            column(UserN; UserId) { }
            column(Amt; Amt) { }
            column(DocName; DocNM) { }
            column(UAmt; UAmt) { }
            column(AdminNo; HMSPatRec."Current Ward") { }
            column(Names; HMSPatRec."Search Name") { }
            column(InsurancePaidAmount; "HMS Patient Charges"."Insurance Paid Amount") { }

            trigger OnAfterGetRecord()
            begin

                //Get bills
                /*PatientCharges.RESET;
                PatientCharges.SETRANGE(PatientCharges."Patient No.","Patient No.");
                PatientCharges.SETRANGE(PatientCharges.Closed,FALSE);
                PatientCharges.SETRANGE(PatientCharges.Posted,FALSE);
                PatientCharges.SETFILTER(PatientCharges.Amount,'>0');
                IF "HMS Patient Charges"."Visit No"<>'' THEN
                 PatientCharges.SETRANGE(PatientCharges."Visit No","HMS Patient Charges"."Visit No");
                IF PatientCharges.FIND('-') THEN REPEAT
                 Bills:=Bills+PatientCharges.Amount;
                UNTIL PatientCharges.NEXT=0;
                */

                //Get Receipts
                /*PatientCharges.RESET;
                PatientCharges.SETRANGE(PatientCharges."Patient No.","Patient No.");
                PatientCharges.SETFILTER(PatientCharges.Amount,'<0');
                IF "HMS Patient Charges"."Visit No"<>'' THEN
                 PatientCharges.SETRANGE(PatientCharges."Visit No","HMS Patient Charges"."Visit No");
                IF PatientCharges.FIND('-') THEN REPEAT
                 Receipts:=Receipts+PatientCharges.Amount;
                UNTIL PatientCharges.NEXT=0;
                */
                //************************************************************



                if HMSPatRec.Get("HMS Patient Charges"."Patient No.") then begin
                    HMSPatRec.SetFilter(HMSPatRec."Appointment No Filter", "HMS Patient Charges"."Appointment No.");
                    HMSPatRec.CalcFields(HMSPatRec."Current Ward");
                    if HMSPatRec.Inpatient = false then "HMS Patient Charges".SetFilter("HMS Patient Charges"."Visit No", GetFilter("Visit No"));
                    HMSPatRec.CalcFields("Bill Balance");
                    HMSPatRec.CalcFields("Invoice Amount");
                    HMSPatRec.CalcFields("Receipt Amount");
                end;
                if "HMS Patient Charges".Quantity = 0 then
                    Qty := 1
                else
                    Qty := "HMS Patient Charges".Quantity;
                Amt := 0;
                UAmt := 0;

                Amt := "HMS Patient Charges".Amount * Qty;
                UAmt := "HMS Patient Charges".Amount;

                if "HMS Patient Charges".Amount < 0 then
                    ReceiptAmt := ReceiptAmt + "HMS Patient Charges".Amount;

                if "HMS Patient Charges".Amount > 0 then
                    if "HMS Patient Charges"."Insurance Amount" > 0 then begin
                        Amt := "HMS Patient Charges"."Insurance Amount" * Qty;
                        UAmt := "HMS Patient Charges"."Insurance Amount";
                        // RunBal:=RunBal+("HMS Patient Charges"."Insurance Amount"*Qty);
                    end else begin
                        Amt := "HMS Patient Charges".Amount * Qty;
                        UAmt := "HMS Patient Charges".Amount;

                    end;
                if "HMS Patient Charges".Amount > 0 then
                    InvAmt := InvAmt + Amt;


                //Get Receipts
                PatientCharges.Reset;
                PatientCharges.SetRange(PatientCharges."Patient No.", "Patient No.");
                PatientCharges.SetFilter(PatientCharges.Amount, '<0');
                PatientCharges.SetFilter(PatientCharges."Visit No", GetFilter("Visit No"));
                /*
                IF "HMS Patient Charges"."Visit No"<>'' THEN
                 PatientCharges.SETRANGE(PatientCharges."Visit No","HMS Patient Charges"."Visit No");
                 */
                if PatientCharges.Find('-') then
                    repeat
                        Receipts := Receipts + PatientCharges.Amount;
                    until PatientCharges.Next = 0;

                RunBal := RunBal + Amt;
                Bal := RunBal;

                DocNM := '';

                if DocRec.Get("HMS Patient Charges"."Doctor ID") then DocNM := DocRec."Doctors Name" + ' (' + DocRec.Specialization + ')';
                AdmissionDates := '';
                DischargeDates := '';
                if HMSPatRec."Admissions Date" <> 0D then AdmissionDates := 'Admission Date: ' + Format(HMSPatRec."Admissions Date");
                if HMSPatRec."Discharge Date" <> 0D then DischargeDates := 'Discharge Date: ' + Format(HMSPatRec."Discharge Date");

                Ward_ := '';

                AdmRec.Reset;
                AdmRec.SetRange(AdmRec."Patient No.", "HMS Patient Charges"."Patient No.");
                AdmRec.SetRange(AdmRec.Status, AdmRec.Status::Admitted);
                if AdmRec.Find('-') then begin
                    Ward_ := 'Ward: ' + AdmRec.Ward;
                    Beds_ := 'Bed: ' + AdmRec.Bed;
                end;

                if "HMS Patient Charges"."Transaction Type" = 'ZRECEIPT' then begin
                    TranType := 'RECEIPTS';
                    if "HMS Patient Charges".Code = 'REBATES' then
                        TransDec := 'NHIF Rebates'
                    else
                        TransDec := 'Payment Receipt';
                end else begin
                    TranType := "HMS Patient Charges"."Transaction Type";
                    TransDec := "HMS Patient Charges".Description;
                end;

            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);

                HMSCharges.Reset;
                HMSCharges.SetFilter(HMSCharges."Patient No.", GetFilter("Patient No."));
                if HMSCharges.Find('-') then begin
                    //REPEAT
                    // HMSPat.CalculateTotalCharges(HMSCharges."Patient No.");
                    /*
                    IF HMSCharges.Quantity=0 THEN
                      Qty:=1
                   ELSE
                      Qty:=HMSCharges.Quantity;
                    Amt:=0;
                      IF HMSCharges."Insurance Amount">0 THEN
                      Amt:=HMSCharges."Insurance Amount"*Qty
                  ELSE
                     Amt:=HMSCharges.Amount*Qty;
                   HMSCharges.Quantity:=Qty;
                   HMSCharges."Total Amount":=Amt;
                   HMSCharges.MODIFY;
                   */
                    // UNTIL HMSCharges.NEXT=0;
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

    var
        RunBal: Decimal;
        ReceiptAmt: Decimal;
        InvAmt: Decimal;
        Bal: Decimal;
        HMSPatRec: Record "HMS Patient";
        CompInf: Record "Company Information";
        Amt: Decimal;
        DocRec: Record "HMS Setup Doctor";
        decQuantity: Decimal;
        Qty: Decimal;
        UAmt: Decimal;
        DocNM: Text;
        HMSCharges: Record "HMS Patient Charges";
        AdmissionDates: Text;
        DischargeDates: Text;
        Ward_: Text;
        Beds_: Text;
        AdmRec: Record "HMS Admission Form Header";
        Receipts: Decimal;
        PatientCharges: Record "HMS Patient Charges";
        TranType: Code[20];
        TransDec: Text[100];
}

