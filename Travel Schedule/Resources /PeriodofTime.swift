//
//  PeriodofTime.swift
//  Travel Schedule
//
//  Created by Дионисий Коневиченко on 14.07.2025.
//

import Foundation

/// Перечисление периодов времени для фильтрации расписания
enum PeriodofTime: String, CaseIterable, Hashable, @unchecked Sendable {
    case morning = "Утро 06:00 - 12:00"
    case day = "День 12:00 - 18:00"
    case evening = "Вечер 18:00 - 00:00"
    case night = "Ночь 00:00 - 06:00"
}
