//
//  Functions+Composite.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/15/24.
//

infix operator |>: AdditionPrecedence

func |> <T>(lhs: @escaping (T) -> Void, rhs: @escaping () -> Void) -> (T) -> Void {
    return { t in
        lhs(t)
        rhs()
    }
}
