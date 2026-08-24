/// <summary>
/// SSP Facility UAT — maintenance actions (R35-R44), work-ticket flight booking
/// (R45-R48) and procurement budget template (R59-R61).
/// PUBLISH AS SOAP WEB SERVICE: object = this codeunit, Service Name = "CuPortalFacility".
/// Parameter names must not be changed — the portal backend calls them by name.
/// </summary>
codeunit 52161 "Portal Facility Mgt."
{
    // ---------------------------------------------------------------------
    // Maintenance (FLT Fuel & Maintenance Req. 50865 companion, table 52163)
    // ---------------------------------------------------------------------

    /// <summary>UAT R20/R21: retain the vehicle/card fuel-standard context and current odometer.</summary>
    procedure SaveFuelRequestStandard(requisitionNo: Code[20]; employeeNo: Code[20]; vehicleNo: Code[30]; currentOdometer: Decimal; requestedLitres: Decimal): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
        Vehicle: Record "FLT-Vehicle Header";
        FuelRequest: Record "FLT-Fuel & Maintenance Req.";
    begin
        if requisitionNo = '' then
            exit(false);
        EnsureMaintenanceExtra(Extra, requisitionNo);
        Extra."Employee No." := employeeNo;
        Extra."Request Type" := 0;
        Extra."Vehicle No." := vehicleNo;
        Extra."Current Odometer" := currentOdometer;
        Extra."Requested Fuel Litres" := requestedLitres;

        Vehicle.Reset();
        Vehicle.SetRange("Registration No.", vehicleNo);
        if Vehicle.FindFirst() then begin
            Extra."Vehicle Fuel Rating" := Vehicle."Fuel Rating";
            Extra."Vehicle Current Reading" := Vehicle."Current Reading";
        end else begin
            Vehicle.Reset();
            if Vehicle.Get(vehicleNo) then begin
                Extra."Vehicle Fuel Rating" := Vehicle."Fuel Rating";
                Extra."Vehicle Current Reading" := Vehicle."Current Reading";
            end;
        end;
        Extra.Modify(true);

        if FuelRequest.Get(requisitionNo) then begin
            FuelRequest."Initial Odometer Reading" := currentOdometer;
            FuelRequest.Modify(true);
        end;
        exit(true);
    end;

    /// <summary>Stamp a portal-created FLT requisition as a maintenance request and store the SSP template fields.</summary>
    procedure MarkAsMaintenanceRequest(requisitionNo: Code[20]; employeeNo: Code[20]; requestType: Integer; faTagNumber: Code[30]; vehicleNo: Code[30]; item: Text[100]; quantity: Decimal; priority: Text[20]; location: Text[100]; issueDescription: Text[500]; currentOdometer: Decimal; lastServiceOdometer: Decimal): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
        FixedAsset: Record "Fixed Asset";
        Vehicle: Record "FLT-Vehicle Header";
        FuelRequest: Record "FLT-Fuel & Maintenance Req.";
        ValidatedFATag: Code[30];
        ValidatedVehicleNo: Code[30];
    begin
        if requisitionNo = '' then
            exit(false);

        case requestType of
            1:
                begin
                    ResolveFixedAssetAndEnsureTag(faTagNumber, FixedAsset);
                    ValidatedFATag := CopyStr(FixedAsset."Asset Tag", 1, MaxStrLen(ValidatedFATag));
                    if ValidatedFATag = '' then
                        ValidatedFATag := CopyStr(FixedAsset."No.", 1, MaxStrLen(ValidatedFATag));
                end;
            2:
                begin
                    if vehicleNo = '' then
                        Error('Vehicle Registration Number is required for vehicle service maintenance.');
                    Vehicle.Reset();
                    Vehicle.SetRange("Registration No.", vehicleNo);
                    if not Vehicle.FindFirst() then
                        Error('Vehicle Registration Number %1 was not found. Select a current vehicle from Business Central.', vehicleNo);
                    if not FixedAsset.Get(Vehicle."No.") then
                        Error('Vehicle %1 is not linked to Fixed Asset %2. Complete the vehicle Fixed Asset setup in Business Central.', vehicleNo, Vehicle."No.");
                    EnsureFixedAssetTag(FixedAsset);
                    if (faTagNumber <> '') and
                       (FixedAsset."No." <> faTagNumber) and
                       (FixedAsset."Asset Tag" <> faTagNumber)
                    then
                        Error('Fixed Asset %1 does not belong to vehicle %2. The linked Fixed Asset is %3 (Tag %4).', faTagNumber, vehicleNo, FixedAsset."No.", FixedAsset."Asset Tag");
                    ValidatedFATag := CopyStr(FixedAsset."Asset Tag", 1, MaxStrLen(ValidatedFATag));
                    if ValidatedFATag = '' then
                        ValidatedFATag := CopyStr(FixedAsset."No.", 1, MaxStrLen(ValidatedFATag));
                    ValidatedVehicleNo := CopyStr(Vehicle."Registration No.", 1, MaxStrLen(ValidatedVehicleNo));
                end;
            else
                Error('Maintenance Request Type %1 is invalid. Select Fixed Asset Maintenance or Vehicle Service Maintenance.', requestType);
        end;

        if not FuelRequest.Get(requisitionNo) then
            Error('Maintenance requisition %1 was not found.', requisitionNo);
        FuelRequest.Type := FuelRequest.Type::Maintenance;
        FuelRequest."Fixed Asset No" := FixedAsset."No.";
        if requestType = 1 then
            FuelRequest."Vehicle Reg No" := ''
        else
            FuelRequest."Vehicle Reg No" := ValidatedVehicleNo;
        FuelRequest.Modify(true);

        if not Extra.Get(requisitionNo) then begin
            Extra.Init();
            Extra."Requisition No." := requisitionNo;
            Extra.Insert(true);
        end;
        Extra."Employee No." := employeeNo;
        Extra."Request Type" := requestType;
        Extra."FA Tag Number" := ValidatedFATag;
        Extra."Vehicle No." := ValidatedVehicleNo;
        Extra.Item := item;
        Extra.Quantity := quantity;
        Extra.Priority := priority;
        Extra.Location := location;
        Extra."Issue Description" := issueDescription;
        if currentOdometer > 0 then begin
            Extra."Current Odometer" := currentOdometer;
            Extra."Next Service KM" := currentOdometer + 5000; // R41: service due every 5,000 km
        end;
        if lastServiceOdometer > 0 then
            Extra."Last Service Odometer" := lastServiceOdometer;
        Extra.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R39: technical manager assigns an internal technician.</summary>
    procedure AssignMaintenanceTechnician(requisitionNo: Code[20]; technicianNo: Code[20]; myUserID: Code[50]): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
        Technician: Record "HR-Employee";
    begin
        if (requisitionNo = '') or (technicianNo = '') then
            exit(false);
        if not Technician.Get(technicianNo) then
            Error('Employee %1 was not found. Select an internal technician from the employee list.', technicianNo);
        EnsureMaintenanceExtra(Extra, requisitionNo);
        Extra."Assigned Technician" := technicianNo;
        Extra."Assigned Technician Name" := CopyStr(Technician."Full Name", 1, MaxStrLen(Extra."Assigned Technician Name"));
        Extra."Assigned By" := myUserID;
        Extra."Assigned On" := CurrentDateTime;
        Extra.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R40: requestor confirms receipt of the maintained FA / vehicle.</summary>
    procedure ConfirmMaintenanceReceipt(requisitionNo: Code[20]; remarks: Text[100]; myUserID: Code[50]): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
    begin
        if requisitionNo = '' then
            exit(false);
        EnsureMaintenanceExtra(Extra, requisitionNo);
        Extra."FA Received By" := myUserID;
        Extra."FA Received Date" := Today;
        Extra."Receipt Remarks" := remarks;
        Extra.Modify(true);
        exit(true);
    end;

    local procedure ResolveFixedAssetAndEnsureTag(assetReference: Code[30]; var FixedAsset: Record "Fixed Asset")
    begin
        if assetReference = '' then
            Error('Fixed Asset is required for fixed asset maintenance.');

        FixedAsset.Reset();
        if not FixedAsset.Get(assetReference) then begin
            // Backward compatibility for portal builds that submitted the
            // physical Asset Tag instead of the stable Fixed Asset No.
            FixedAsset.Reset();
            FixedAsset.SetRange("Asset Tag", assetReference);
            if not FixedAsset.FindFirst() then
                Error('Fixed Asset %1 was not found. Select a current fixed asset from Business Central.', assetReference);
        end;

        EnsureFixedAssetTag(FixedAsset);
    end;

    local procedure EnsureFixedAssetTag(var FixedAsset: Record "Fixed Asset")
    var
        AssetConversionSetup: Record "Asset Capitalization Setup";
        AssetTagNoSeries: Codeunit "No. Series";
        GeneratedTag: Code[20];
    begin
        // UAT HB 11/08/2026 v3 (CuPortalFacility): MarkAsMaintenanceRequest was still
        // Erroring when Generate Asset Tags = Off. Always stamp a tag when blank —
        // prefer No. Series when configured, otherwise Fixed Asset "No.".
        if FixedAsset."Asset Tag" <> '' then
            exit;

        GeneratedTag := '';
        if AssetConversionSetup.Get() then
            if AssetConversionSetup."Generate Asset Tags" and (AssetConversionSetup."Asset Tag Nos." <> '') then
                GeneratedTag :=
                    AssetTagNoSeries.GetNextNo(AssetConversionSetup."Asset Tag Nos.", Today(), true);

        if GeneratedTag = '' then
            GeneratedTag := CopyStr(FixedAsset."No.", 1, MaxStrLen(FixedAsset."Asset Tag"));

        if GeneratedTag = '' then
            exit;

        FixedAsset."Asset Tag" := GeneratedTag;
        FixedAsset.Modify(false);
    end;

    /// <summary>UAT R41/R42: save odometer readings; Next Service KM = current + 5,000.</summary>
    procedure SaveMaintenanceOdometer(requisitionNo: Code[20]; currentOdometer: Decimal; lastServiceOdometer: Decimal): Boolean
    var
        Extra: Record "Portal Fuel Maint. Extra";
    begin
        if (requisitionNo = '') or (currentOdometer <= 0) then
            exit(false);
        EnsureMaintenanceExtra(Extra, requisitionNo);
        Extra."Current Odometer" := currentOdometer;
        if lastServiceOdometer > 0 then
            Extra."Last Service Odometer" := lastServiceOdometer;
        Extra."Next Service KM" := currentOdometer + 5000;
        Extra.Modify(true);
        exit(true);
    end;

    local procedure EnsureMaintenanceExtra(var Extra: Record "Portal Fuel Maint. Extra"; requisitionNo: Code[20])
    begin
        if Extra.Get(requisitionNo) then
            exit;
        Extra.Init();
        Extra."Requisition No." := requisitionNo;
        Extra.Insert(true);
    end;

    // ---------------------------------------------------------------------
    // Transport (FLT-Transport Requisition 50863)
    // ---------------------------------------------------------------------

    /// <summary>
    /// UAT Facility R30: lets the approver assign a vehicle from the SSP
    /// approval screen instead of only inside Business Central. Setting
    /// "Vehicle Allocated" runs the table's own OnValidate — it re-checks
    /// the vehicle is not already allocated to an overlapping trip (raises
    /// the same Error() BC itself would show) and auto-fills Driver
    /// Allocated, Vehicle Registration and "Vehicle Allocated by" exactly as
    /// assigning it manually in BC would.
    /// </summary>
    procedure AssignTransportVehicle(reqNo: Code[20]; vehicleNo: Code[20]; myUserID: Code[50]): Boolean
    var
        TransportReq: Record "FLT-Transport Requisition";
        Vehicle: Record "FLT-Vehicle Header";
        ResolvedVehicleNo: Code[20];
    begin
        if (reqNo = '') or (vehicleNo = '') then
            exit(false);
        if not TransportReq.Get(reqNo) then
            Error('Transport requisition %1 was not found.', reqNo);

        // SSP dropdown sends Registration No.; field TableRelation is Vehicle."No.".
        ResolvedVehicleNo := vehicleNo;
        if not Vehicle.Get(vehicleNo) then begin
            Vehicle.Reset();
            Vehicle.SetRange("Registration No.", vehicleNo);
            if not Vehicle.FindFirst() then
                Error('Vehicle %1 was not found in FLT-Vehicle Header.', vehicleNo);
            ResolvedVehicleNo := Vehicle."No.";
        end;

        TransportReq.Validate("Vehicle Allocated", ResolvedVehicleNo);
        exit(TransportReq.Modify(true));
    end;

    // ---------------------------------------------------------------------
    // Work ticket flight booking (FLT Work Ticket 50866 companion, table 52162)
    // ---------------------------------------------------------------------

    /// <summary>UAT R45/R46: save the flight-booking fields of a work ticket.</summary>
    procedure SaveWorkTicketFlightDetails(ticketNo: Code[20]; travelerEmployeeNo: Code[20]; flightFrom: Text[100]; flightTo: Text[100]; departureDate: Text; returnDate: Text; ticketClass: Integer; airlinePreference: Text[100]; justification: Text[250]): Boolean
    var
        Flight: Record "Portal Work Ticket Flight";
        Employee: Record Employee;
        ParsedDate: Date;
    begin
        if (ticketNo = '') or (flightFrom = '') or (flightTo = '') then
            exit(false);
        if not ParsePortalDate(departureDate, ParsedDate) then
            exit(false);
        if not Flight.Get(ticketNo) then begin
            Flight.Init();
            Flight."Ticket No." := ticketNo;
            Flight.Insert(true);
        end;
        Flight."Booking Type" := 'Flight';
        Flight."Traveler Employee No." := travelerEmployeeNo;
        if Employee.Get(travelerEmployeeNo) then
            Flight."Traveler Name" := CopyStr(Employee.FullName(), 1, MaxStrLen(Flight."Traveler Name"));
        Flight."Flight From" := flightFrom;
        Flight."Flight To" := flightTo;
        Flight."Departure Date" := ParsedDate;
        if ParsePortalDate(returnDate, ParsedDate) then
            Flight."Return Date" := ParsedDate
        else
            Flight."Return Date" := 0D;
        if ticketClass = 2 then
            Flight."Ticket Class" := 'Business'
        else
            Flight."Ticket Class" := 'Economy';
        Flight."Airline Preference" := airlinePreference;
        Flight."Booking Justification" := justification;
        Flight.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R48: record the booking confirmation receipt.</summary>
    procedure ConfirmWorkTicketBooking(ticketNo: Code[20]; confirmationNo: Code[50]; myUserID: Code[50]): Boolean
    var
        Flight: Record "Portal Work Ticket Flight";
    begin
        if (ticketNo = '') or (confirmationNo = '') then
            exit(false);
        if not Flight.Get(ticketNo) then begin
            Flight.Init();
            Flight."Ticket No." := ticketNo;
            Flight.Insert(true);
        end;
        Flight."Booking Confirmation No." := confirmationNo;
        Flight."Booking Confirmed" := true;
        Flight."Booking Confirmed Date" := Today;
        Flight."Confirmed By" := myUserID;
        Flight.Modify(true);
        exit(true);
    end;

    /// <summary>UAT R47: submit a completed work-ticket / flight booking to the configured manager workflow.</summary>
    procedure RequestWorkTicketApproval(ticketNo: Code[20]): Boolean
    var
        WorkTicket: Record "FLT-Daily Work Ticket Header";
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        Variant: Variant;
    begin
        if ticketNo = '' then
            exit(false);
        if not WorkTicket.Get(ticketNo) then
            Error('Work ticket %1 was not found.', ticketNo);
        Variant := WorkTicket;
        if not CustomApprovals.CheckApprovalsWorkflowEnabled(Variant) then
            Error('No approval workflow is enabled for work tickets.');
        CustomApprovals.OnSendDocForApproval(Variant);
        exit(true);
    end;

    /// <summary>Cancel a pending work-ticket approval request before a manager decision.</summary>
    procedure CancelWorkTicketApproval(ticketNo: Code[20]): Boolean
    var
        WorkTicket: Record "FLT-Daily Work Ticket Header";
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        Variant: Variant;
    begin
        if ticketNo = '' then
            exit(false);
        if not WorkTicket.Get(ticketNo) then
            Error('Work ticket %1 was not found.', ticketNo);
        Variant := WorkTicket;
        CustomApprovals.OnCancelDocApprovalRequest(Variant);
        exit(true);
    end;

    // ---------------------------------------------------------------------
    // Procurement budget template (tables 52164 / 52165)
    // ---------------------------------------------------------------------

    /// <summary>UAT R59: department or district opens a budget template.</summary>
    procedure SaveProcurementPlanHeader(budgetName: Code[50]; globalDim1: Code[20]; globalDim2: Code[20]; planPeriod: Code[20]): Boolean
    var
        Header: Record "Portal Procurement Plan Hdr.";
    begin
        if (budgetName = '') or (planPeriod = '') then
            exit(false);
        if globalDim2 = '' then
            Error('Department or District is required to open a procurement budget template.');
        if Header.Get(budgetName, globalDim1, globalDim2, planPeriod) then
            exit(true); // already exists — idempotent
        Header.Init();
        Header."Budget Name" := budgetName;
        Header."Global Dimension 1" := globalDim1;
        Header."Global Dimension 2" := globalDim2;
        Header."Plan Period" := planPeriod;
        Header.Status := 'Open';
        Header."Created By" := CopyStr(UserId(), 1, MaxStrLen(Header."Created By"));
        Header.Insert(true);
        exit(true);
    end;

    /// <summary>UAT R60: itemised procurement budget plan line (upsert).</summary>
    procedure SaveProcurementPlanLine(budgetName: Code[50]; department: Code[20]; lineType: Integer; typeNo: Code[30]; globalDim1: Code[20]; planPeriod: Code[20]; quantity: Decimal; unitCost: Decimal; planDate: Text): Boolean
    var
        Line: Record "Portal Procurement Plan Line";
        ParsedDate: Date;
    begin
        if (budgetName = '') or (typeNo = '') or (planPeriod = '') then
            exit(false);
        if department = '' then
            Error('Department or District is required on each procurement budget line.');
        if PlanIsSubmitted(budgetName, globalDim1, department, planPeriod) then
            Error('Procurement plan %1 / %2 has already been submitted and can no longer be changed.', budgetName, planPeriod);
        if not Line.Get(budgetName, department, lineType, typeNo, globalDim1, planPeriod) then begin
            Line.Init();
            Line."Budget Name" := budgetName;
            Line.Department := department;
            Line.Type := lineType;
            Line."Type No." := typeNo;
            Line."Global Dimension 1" := globalDim1;
            Line."Plan Period" := planPeriod;
            Line.Insert(true);
        end;
        Line.Description := ResolvePlanLineDescription(lineType, typeNo);
        Line.Quantity := quantity;
        Line."Unit Cost" := unitCost;
        Line.Amount := quantity * unitCost;
        if ParsePortalDate(planDate, ParsedDate) then
            Line."Plan Date" := ParsedDate;
        Line.Modify(true);
        exit(true);
    end;

    /// <summary>Remove one plan line (blocked after submission).</summary>
    procedure DeleteProcurementPlanLine(budgetName: Code[50]; department: Code[20]; lineType: Integer; typeNo: Code[30]; globalDim1: Code[20]; planPeriod: Code[20]): Boolean
    var
        Line: Record "Portal Procurement Plan Line";
    begin
        if PlanIsSubmitted(budgetName, globalDim1, department, planPeriod) then
            Error('Procurement plan %1 / %2 has already been submitted and can no longer be changed.', budgetName, planPeriod);
        if not Line.Get(budgetName, department, lineType, typeNo, globalDim1, planPeriod) then
            exit(false);
        Line.Delete(true);
        exit(true);
    end;

    /// <summary>UAT R61: submit the itemised procurement budget plan.</summary>
    procedure SubmitProcurementPlan(budgetName: Code[50]; globalDim1: Code[20]; globalDim2: Code[20]; planPeriod: Code[20]): Boolean
    var
        Header: Record "Portal Procurement Plan Hdr.";
        Line: Record "Portal Procurement Plan Line";
    begin
        if not Header.Get(budgetName, globalDim1, globalDim2, planPeriod) then
            exit(false);
        Line.SetRange("Budget Name", budgetName);
        Line.SetRange("Global Dimension 1", globalDim1);
        Line.SetRange(Department, globalDim2);
        Line.SetRange("Plan Period", planPeriod);
        if Line.IsEmpty() then
            Error('Add at least one plan line before submitting procurement plan %1 / %2.', budgetName, planPeriod);
        Header.Status := 'Submitted';
        Header."Submitted On" := CurrentDateTime;
        Header.Modify(true);
        exit(true);
    end;

    local procedure PlanIsSubmitted(budgetName: Code[50]; globalDim1: Code[20]; globalDim2: Code[20]; planPeriod: Code[20]): Boolean
    var
        Header: Record "Portal Procurement Plan Hdr.";
    begin
        Header.SetRange("Budget Name", budgetName);
        Header.SetRange("Global Dimension 1", globalDim1);
        Header.SetRange("Global Dimension 2", globalDim2);
        Header.SetRange("Plan Period", planPeriod);
        Header.SetRange(Status, 'Submitted');
        exit(not Header.IsEmpty());
    end;

    local procedure ResolvePlanLineDescription(lineType: Integer; typeNo: Code[30]): Text[100]
    var
        GLAccount: Record "G/L Account";
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
    begin
        case lineType of
            1:
                if GLAccount.Get(typeNo) then
                    exit(CopyStr(GLAccount.Name, 1, 100));
            3:
                if FixedAsset.Get(typeNo) then
                    exit(CopyStr(FixedAsset.Description, 1, 100));
            else
                if Item.Get(typeNo) then
                    exit(CopyStr(Item.Description, 1, 100));
        end;
        exit(typeNo);
    end;

    /// <summary>Accepts the SSP date formats: yyyy-mm-dd (XML) or the BC locale format.</summary>
    local procedure ParsePortalDate(value: Text; var result: Date): Boolean
    begin
        result := 0D;
        value := DelChr(value, '<>', ' ');
        if value = '' then
            exit(false);
        if Evaluate(result, value, 9) then
            exit(true);
        exit(Evaluate(result, value));
    end;

    // ---------------------------------------------------------------------
    // Approval card routing (UAT R22-R24)
    // Fuel and maintenance share table 50865 "FLT-Fuel & Maintenance Req.".
    // The legacy default card (page 50634 "FLT Maintenance Request Sub.")
    // filters Type = Maintenance, so a *fuel* document opened from an approval
    // entry or record link resolves to a blank "maintenance" card. Route the
    // shared table to the neutral "Portal Fleet Approval Card" (52172), which
    // shows the fuel or maintenance fields by Type. Mirrors the existing
    // "Page Management Ext" (50022) routing used for approval documents such
    // as Payments Header.
    // ---------------------------------------------------------------------
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', true, true)]
    local procedure RouteFleetFuelMaintApprovalCard(RecordRef: RecordRef; var PageID: Integer)
    begin
        if RecordRef.Number = Database::"FLT-Fuel & Maintenance Req." then
            PageID := Page::"Portal Fleet Approval Card";
    end;
}
